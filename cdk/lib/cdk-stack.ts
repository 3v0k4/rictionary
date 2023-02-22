import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as ecs from "aws-cdk-lib/aws-ecs";
import * as elbv2 from "aws-cdk-lib/aws-elasticloadbalancingv2";
import * as ec2 from "aws-cdk-lib/aws-ec2";

const APP = "rictionary";

export class CdkStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const cluster = new ecs.Cluster(this, `${APP}-ecs-cluster`, {
      clusterName: `${APP}-cluster`,
    });

    const taskDefinition = new ecs.FargateTaskDefinition(
      this,
      `${APP}-ecs-task-definition`,
      {
        memoryLimitMiB: 512,
        cpu: 256,
      }
    );

    const container = taskDefinition.addContainer(`${APP}-container`, {
      image: ecs.ContainerImage.fromAsset("../"),
      memoryLimitMiB: 512,
      logging: ecs.LogDrivers.awsLogs({
        streamPrefix: `${APP}-logs`,
      }),
      environment: {
        PORT: "80",
        SECRET_KEY_BASE: "1",
      },
    });

    container.addPortMappings({
      containerPort: 80,
      hostPort: 80,
      protocol: ecs.Protocol.TCP,
    });

    const service = new ecs.FargateService(this, `${APP}-fargate-service`, {
      cluster,
      taskDefinition,
      desiredCount: 1,
    });

    const alb = new elbv2.ApplicationLoadBalancer(this, `${APP}-ALB`, {
      vpc: cluster.vpc,
      internetFacing: true,
    });

    alb.connections.allowFromAnyIpv4(ec2.Port.tcp(80));
    cluster.connections.allowFrom(alb, ec2.Port.tcp(80));

    const listener = alb.addListener(`${APP}-listener`, {
      port: 80,
      open: true,
    });

    listener.addTargets(`${APP}-target`, {
      port: 80,
      targets: [service],
      healthCheck: {
        path: "/",
        interval: cdk.Duration.seconds(60),
        timeout: cdk.Duration.seconds(5),
      },
    });

    new cdk.CfnOutput(this, "LoadBalancerDNS", {
      value: alb.loadBalancerDnsName,
    });

    new cdk.CfnOutput(this, "LoadBalancerDNSName", {
      value: alb.loadBalancerFullName,
    });
  }
}
