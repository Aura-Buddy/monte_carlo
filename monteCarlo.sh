echo > outputFile.txt
IFS=''
j=12
k=32
flag=0

function removeFile {
	rm outputFile.txt
}

function restartDocker {
	killall Docker
	open -a Docker
	while ! docker system info > /dev/null 2>&1; do sleep 1; done
	docker container prune -f
}

function startNetwork {
	cp outputFile.txt /Users/aurachristinateasley/fresh-fabric/fabric-samples/test-network/configtx/configtx.yaml
	./startFabric.sh
	pushd /Users/aurachristinateasley/fresh-fabric/fabric-samples/fabcar/go
	(time go run experimentalFastConcurrency.go) &>CPUandTime"$j""$k".txt
	go run queryAllHighThroughput.go &>ledger"$j""$k".txt
	docker logs -t peer0.org1.example.com &>peerLog"$j""$k".txt
	mv ledger"$j""$k".txt /Users/aurachristinateasley/Desktop/"Lab Meetings"/"Weekly Pursuits 4.12 - 4.19"/MonteCarloResults/Ledger
	mv CPUandTime"$j""$k".txt /Users/aurachristinateasley/Desktop/"Lab Meetings"/"Weekly Pursuits 4.12 - 4.19"/MonteCarloResults/CPUandTime
	mv peerLog"$j""$k".txt /Users/aurachristinateasley/Desktop/"Lab Meetings"/"Weekly Pursuits 4.12 - 4.19"/MonteCarloResults/PeerLog
	popd
	restartDocker
}

function decrementK () {
	k=2
}

function incrementK () {
	k=$(($k+2))
}

function incrementJ () {
	j=$(($j+2))
}

function readFile () {
	removeFile
	input="/Users/aurachristinateasley/Desktop/configtx.yaml" 
	while read data; do 
		if [ "$data" == "    BatchTimeout: 0s" ]; then
			echo "    BatchTimeout: "$j"s" >> outputFile.txt
		elif [ "$data" == "        MaxMessageCount: 0" ]; then
			echo "        MaxMessageCount: "$k"" >> outputFile.txt
		else
			echo $data >> outputFile.txt
		fi
	done < $input
	startNetwork
	if [ $k -ge 50 ]; then
		incrementJ
		decrementK
	fi
	incrementK
	echo "Done: j is now $j, k is now $k"
}

while [ $j -le 50 ]; do
        readFile $j $k
done
