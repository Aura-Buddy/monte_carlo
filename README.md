# monte_carlo

This scripts changes the hyperparameters of hyperledger fabric via the configtx.yaml file
Parameters changed:
Block Size
Batch Timeout

The script will perform 625 iterations of changes to these parameters and generate logs of the peer response, ledger content, time elapsed and cpu utilization.

Some qualities were hard coded so you many need to change a few things if you wish to apply for your set up
