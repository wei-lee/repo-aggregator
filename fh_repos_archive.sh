#!/bin/bash
repos=("fh-nodeapp=git@github.com:fheng/fh-nodeapp.git"
       "fh-dynofarm-cluster-sync=git@github.com:fheng/fh-dynofarm-cluster-sync.git"
       "fh-studio=git@github.com:fheng/fh-studio.git"
       "millicore=git@github.com:fheng/millicore.git"
       "fh-dynofarm=git@github.com:fheng/fh-dynofarm.git"
       "fhcap=git@github.com:fheng/fhcap.git"
       "df-art=git@github.com:fheng/df-art.git"
       "fh-dfc=git@github.com:fheng/fh-dfc.git"
       "fh-docs=git@github.com:fheng/fh-docs.git"
       "fh-core=git@github.com:fheng/fh-core.git"
       "fh-node-common=git@github.com:fheng/fh-node-common.git"
       "fh-art=git@github.com:fheng/fh-art.git"
       "fh-hat=git@github.com:fheng/fh-hat.git"
       "fh-messaging=git@github.com:fheng/fh-messaging.git"
       "fh-db=git@github.com:fheng/fh-db.git"
       "fh-ditch=git@github.com:fheng/fh-ditch.git"
       "fh-scm=git@github.com:fheng/fh-scm.git"
       "fh-stats=git@github.com:fheng/fh-stats.git"
       "fh-security=git@github.com:fheng/fh-security.git"
       "fh-reportingclient=git@github.com:fheng/fh-reportingclient.git"
       "fh-device-android=git@github.com:fheng/fh-device-android.git;fh2.2.0"
       "vcap=git@github.com:fheng/vcap.git"
       "fh-device-blackberry=git@github.com:fheng/fh-device-blackberry.git;fhcb-1.2.0"
       "fh-device-windowsphone=git@github.com:fheng/fh-device-windowsphone.git;fhcb-1.3.0"
       "fh-ngui=git@github.com:fheng/fh-ngui.git"
       "fh-digger-node=git@github.com:fheng/fh-digger-node.git"
       "fh-supercore=git@github.com:fheng/fh-supercore.git"
       "fh-forms=git@github.com:fheng/fh-forms.git"
       "formbuilder=git@github.com:fheng/formbuilder.git"
       "fh-mbaas-api=git@github.com:fheng/fh-mbaas-api.git"
       "fh-mbaas-express=git@github.com:fheng/fh-mbaas-express.git"
       "fh-cms=git@github.com:fheng/fh-cms.git"
       "fh-gridfs=git@github.com:fheng/fh-gridfs.git"
       "fh-amqp-js=git@github.com:fheng/fh-amqp-js.git"
       "fh-bodacious=git@github.com:fheng/fh-bodacious.git"
       "fh-aaa=git@github.com:fheng/fh-aaa.git"
       "fh-doxy=git@github.com:fheng/fh-doxy.git"
       "fh-deploy=git@github.com:fheng/fh-deploy.git"
       "fh-service-generator=git@github.com:fheng/fh-service-generator.git"
       "fh-proxy=git@github.com:fheng/fh-proxy.git"
       "fh-dynoman=git@github.com:fheng/fh-dynoman.git"
       "fh-vmvm=git@github.com:fheng/fh-vmvm.git"
       "fh-resource-usage=git@github.com:fheng/fh-resource-usage.git"
       "fh-automatron=git@github.com:fheng/fh-automatron.git"
       "fh-overseer=git@github.com:fheng/fh-overseer.git"
       "fh-mongosync=git@github.com:fheng/fh-mongosync.git"
       "fh-track=git@github.com:fheng/fh-track.git"
       "fh-agent=git@github.com:fheng/fh-agent.git"
       "fh-manatee=git@github.com:fheng/fh-manatee.git"
       "fh-js-api-v2=git@github.com:fheng/fh-js-api-v2.git"
       "fh-log=git@github.com:fheng/fh-log.git"
       "AppForms-Template=git@github.com:feedhenry/AppForms-Template.git"
       "appforms-project-client=git@github.com:feedhenry/appforms-project-client.git"
       "template-config=git@github.com:feedhenry/template-config.git"
       "turbo=git@github.com:feedhenry/turbo.git"
       "fh-fhc=git@github.com:feedhenry/fh-fhc.git"
       "vmcjs=git@github.com:feedhenry/vmcjs.git"
       "fh-connect=git@github.com:feedhenry/fh-connect.git"
       "fh-js-sdk=git@github.com:feedhenry/fh-js-sdk.git"
       "fh-ios-sdk=git@github.com:feedhenry/fh-ios-sdk.git"
       "fh-android-sdk=git@github.com:feedhenry/fh-android-sdk.git"
       "fh-dotnet-sdk=git@github.com:feedhenry/fh-dotnet-sdk.git"
       "monitjs=git@github.com:feedhenry/monitjs.git"
  )

DIR_NAME="fh-repos"
ARCHIVE_DIR_NAME="archives"
rm -rf "master.tar.gz"
if [ -d $ARCHIVE_DIR_NAME ]; then
  rm -rf $ARCHIVE_DIR_NAME
fi
if [ ! -d $DIR_NAME ]; then
 mkdir $DIR_NAME
fi
mkdir $ARCHIVE_DIR_NAME
cd $DIR_NAME

for repo in "${repos[@]}" ; do
  KEY="${repo%%=*}"
  VALUE="${repo##*=}"
  URL=$VALUE
  BRANCH="master"
  if [[ "$VALUE" == *";"* ]]; then
    URL="${VALUE%%;*}"
    BRANCH="${VALUE##*;}"
  fi
  echo "Creating archive for $KEY"
  if [ ! -d "$KEY" ]; then
    echo "Going to clone repo from $URL"
    git clone -b $BRANCH $URL
    cd $KEY
  else
    cd $KEY
    git checkout $BRANCH
    git pull origin $BRANCH
  fi
  echo "$KEY":`git rev-parse --verify HEAD` >> ../../$ARCHIVE_DIR_NAME/repos.txt
  echo "Archive $KEY"
  git archive --format=tar -o "../../$ARCHIVE_DIR_NAME/$KEY.tar.gz" HEAD
  cd ..
done

echo "All repos are archived. Creating master archive..."
cd ..
tar -cvzf master.tar.gz $ARCHIVE_DIR_NAME
echo "Done"