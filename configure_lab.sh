# Enables job control
set -m

# Enables error propagation 
set -e

apt-get update
apt-get install -y unzip

mkdir /stg
# wget http://jsonstudio.com/wp-content/uploads/2014/02/zips.zip
unzip /opt/couchbase/bu.zip
# cd docs
# split -l 1 -a 4 ../zips.json
# for file in *
# do
#   sed -i 's/_id/uuid/g' "$file"
#   mv "$file" "$file.json"
# done

/entrypoint.sh couchbase-server &

sleep 15
#Set up single node of Couchbase, data/query/index, set username and password, enable plasma indexes.
curl --fail -v -X POST http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=300
curl --fail -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex
curl --fail -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password
curl --fail -X POST -u 'Administrator:password' 'http://127.0.0.1:8091/settings/indexes' -d 'indexerThreads=0' -d 'logLevel=info' -d 'maxRollbackPoints=5' -d 'memorySnapshotInterval=200' -d 'stableSnapshotInterval=5000' -d 'storageMode=plasma'

#Create the bucket
couchbase-cli bucket-create -c 127.0.0.1 --bucket=Metadata --bucket-type=couchbase --bucket-ramsize=200 -u Administrator -p password
pwd
#Break the big document into multiple documents
#cbdocloader -u Administrator -p password -n 127.0.0.1:8091 -b sample -s 100 /opt/couchbase/data
sleep 10
# Run cbbackupmgr utility to restore demo data and index definitions
cbbackupmgr restore --archive /bu --repo Metadata -c 127.0.0.1:8091 --username Administrator --password password --no-progress-bar
# create Build indexes
# This version of the configure cluster (single node) enables just the primary index, this is for the lab, where the exercise is to built the indexes to look at improvement in performance.
# curl --fail -v http://Administrator:password@127.0.0.1:8093/query/service -d 'statement=BUILD INDEX ON `Metadata`(`ai_BrowserSnapshots`,`ai_browser_sessions`,`ai_mobile_crash_report`,`idx_mobile_crash_reports1`,`idx_mobile_crash_reports_agg1`)'
curl --fail -v http://Administrator:password@127.0.0.1:8093/query/service -d 'statement=BUILD INDEX ON `Metadata`(`#primary`,`idx_mobile_crash_reports_agg1`)'

fg 1