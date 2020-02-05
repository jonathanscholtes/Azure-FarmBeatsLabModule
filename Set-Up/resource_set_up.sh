#!/bin/sh
az extension add --name azure-cli-iot-ext
RESOURCE_GROUP=rg-FarmBeatLab-$RANDOM
IOT_HUB=IotFarmBeatLab-$RANDOM
STORE=fbstorage$RANDOM
DEVICE_ID=FarmBeatEdgeDevice
LOCATION=centralus

az group create --name $RESOURCE_GROUP --location $LOCATION
az iot hub create --name $IOT_HUB \
   --resource-group $RESOURCE_GROUP --sku S1
az iot hub device-identity create --device-id $DEVICE_ID --hub-name $IOT_HUB --edge-enabled
CONNECTION_STR=`az iot hub device-identity show-connection-string --device-id "$DEVICE_ID" --hub-name "$IOT_HUB"`
echo $CONNECTION_STR

az storage account create \
    --name $STORE \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_LRS 

az storage container create --account-name $STORE --name install

curl -L https://raw.githubusercontent.com/Jscholtes128/Azure-FarmBeatsLabModule/master/Set-Up/iotedgeinstall.sh > iotedgeinstall.sh

sed -i 's/<CONNECTION>/"${CONNECTION_STR}"/g' iotedgeinstall.sh

az storage blob upload \
    --account-name $STORE \
    --container-name install \
    --name iotedgeinstall.sh \
    --file iotedgeinstall.sh

end=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`
az storage blob generate-sas --account-name $STORE -c install -n iotedgeinstall.sh --permissions r --expiry $end --https-only --full-uri
