#!/bin/bash

JENKINS_URL="${jenkins_url}"
JENKINS_USERNAME="${jenkins_username}"
JENKINS_PASSWORD="${jenkins_password}"
TOKEN=$(wget --user=$JENKINS_USERNAME --password=$JENKINS_PASSWORD --auth-no-challenge -q --output-document - ''$JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')

sleep 60

curl -v -u $JENKINS_USERNAME:$JENKINS_PASSWORD -H "$TOKEN" -d 'script=
for (aSlave in hudson.model.Hudson.instance.slaves) {
  println("====================");
  println("Name: ".concat(aSlave.name));
  println("getLabelString: ".concat(aSlave.getLabelString()));
  println("getNumExectutors: ".concat(aSlave.getNumExecutors().toString()));
  println("computer.isAcceptingTasks: ".concat(aSlave.getComputer().isAcceptingTasks().toString()));
  println("computer.isOffline: ".concat(aSlave.getComputer().isOffline().toString()));
  println("computer.countBusy: ".concat(aSlave.getComputer().countBusy().toString()));
  if (aSlave.getComputer().isOffline()) {
    println("shutting down node!!!!");
    aSlave.getComputer().setTemporarilyOffline(true,null);
    aSlave.getComputer().doDoDelete();
  }
}
' $JENKINS_URL/script
