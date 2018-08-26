import { Component, OnInit } from '@angular/core';

import { Web3Service } from "../../util/web3.service";

@Component({
  selector: 'app-meta-sender',
  templateUrl: './meta-sender.component.html',
  styleUrls: ['./meta-sender.component.css']
})
export class MetaSenderComponent implements OnInit {
  constructor(private web3Service: Web3Service) {
    console.log("Constructor: " + web3Service);
  }

  accounts: string[];
  //metaCoinInstance: any;
  marketplaceInstance: any;

  model = {
    amount: 5,
    receiver: "",
    balance: 0,
    account: "",
    isMarketplaceAdministrator:Boolean(false),
    isMarketplaceApprovedStoreOwner:Boolean(false),
    role:"",
    approvedStoreOwners:[],
    marketplaceAdministrator:[],
    myStoresName:[], //as an approvedStoreOwner
    myStoresAddress:[],
    storeProducts:[]
  };

  //marketplaceAdministrator
  //approvedStoreOwner
  //storeShopper

  status = "";

  async ngOnInit() {
    this.watchAccount();
    //this.metaCoinInstance = await this.web3Service.MetaCoin.deployed();
    this.marketplaceInstance = await this.web3Service.Marketplace.deployed();
    //this.refreshBalance() ORIGINAL
    //this.getStoresCountAddress();
    this.getRole();
    this.getMarketplaceApprovedStoreOwners();
    //this.addApprovedStoreOwner();
  }

  watchAccount() {
    this.web3Service.accountsObservable.subscribe({
      next: (accounts) => {
        this.accounts = accounts;
        this.model.account = accounts[0];
        console.log(this.model.account);
      }
    });
  }

  setStatus(status) {
    this.status = status;
  };

  getRole(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    console.log("Getting role, isAdministrator ?");
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.hasRole.call(this.model.account, "marketplaceAdministrator",
    {from: this.model.account }).then((value) => {
      console.log("is role marketplaceAdministrator ? ", value);
      this.model.isMarketplaceAdministrator = value;
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error getting role; see log.");
    });

    //bouchon
    this.model.role = "marketplaceAdministrator";
    //this.model.role = "approvedStoreOwner";
    //this.model.role = "storeShopper";
    //this.model.approvedStoreOwner = ["0xB43688E267e2A08AA0d958c2752527530b0a4dC1","0x542727d6b8E6488bC7Cf8f1CdeE57A7b8F0B79c2","0xf8816C6A7f79b81675Db320aA88eC2F49FC467C2"];
    this.model.myStoresName = ["Car1","Car2"];//as an approvedStoreOwner
    this.model.myStoresAddress = ["0x6a79B6449B9445239dd64A3aE887e6CC3610beD8","0x091f76727893909039A29745e9abBdA8e59cF187"];

    //storeProducts:[]


  };

//<h3>Approved store owners Count : {{this.model.approvedStoreOwners}}</h3>
/*
<head> <script src="angular.js"></script></head>
<body ng-init= "names=['Bob', 'Bill', 'Sarah', 'Robert', 'Sam', 'Jill', 'Dave', 'Larry', 'Jack']">
<ul ng-repeat="firstname in names">
<li>{{firstname}}</li>
</ul>
*/

  getMarketplaceApprovedStoreOwners(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    console.log("Getting approved stores owners ?");
    this.setStatus("Initiating transaction... (please wait)");
//getStores
//getMarketplaceAdministrators
//getApprovedStoreOwners
    this.marketplaceInstance.getApprovedStoreOwners.call(
    {from: this.model.account }).then((value) => {
      console.log("approved store owners ? ", value);
      this.model.approvedStoreOwners = value;
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error getting role; see log.");
    });

  };


  addApprovedStoreOwner(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    console.log("Approving store owner");
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.addRoleApprovedStoreOwner("0xB43688E267e2A08AA0d958c2752527530b0a4dC1",
    {from: this.model.account }).then((success) => {
      if (!success) {
        this.setStatus("Transaction failed!");
      }
      else {
        this.setStatus("Transaction complete!");
        //this.refreshBalance();
      }
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error sending coin; see log.");
    });
  }

/*
      console.log("approved store owners ? ", value);
      this.model.approvedStoreOwners = value;
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error getting role; see log.");
    });

    this.metaCoinInstance.sendCoin(receiver, amount, { from: this.model.account }).then((success) => {
    //this.marketplaceInstance.getStoreCount({ from: this.model.account }).then((success) => {
      if (!success) {
        this.setStatus("Transaction failed!");
      }
      else {
        this.setStatus("Transaction complete!");
        this.refreshBalance();
      }
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error sending coin; see log.");
    });

*/


/*
  getStoresCountAddress(){
    if (!this.marketplaceInstance) {
      this.setStatus("metaCoinInstance is not loaded, unable to send transaction");
      return;
    };

    console.log("Getting store count");
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.getStoreCount({ from: this.model.account }).then((success) => {
      if (!success) {
        this.setStatus("Transaction failed!");
      }
      else {
        this.setStatus("Transaction complete!");
        //this.refreshBalance();
      }
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error sending coin; see log.");
    });

  };
*/

/*
  sendCoin() {
    //if (!this.metaCoinInstance) {
    if (!this.marketplaceInstance) {
      this.setStatus("metaCoinInstance is not loaded, unable to send transaction");
      return;
    }

    console.log("Sending coins" + this.model.amount + " to " + this.model.receiver);

    let amount = this.model.amount;
    let receiver = this.model.receiver;

    this.setStatus("Initiating transaction... (please wait)");

    //this.metaCoinInstance.sendCoin(receiver, amount, { from: this.model.account }).then((success) => {
    this.marketplaceInstance.getStoreCount({ from: this.model.account }).then((success) => {
      if (!success) {
        this.setStatus("Transaction failed!");
      }
      else {
        this.setStatus("Transaction complete!");
        this.refreshBalance();
      }
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error sending coin; see log.");
    });

  };
  */

/*
  refreshBalance() {
    console.log("Refreshing balance");
    this.marketplaceInstance.getStoreCount.call().then((value) => {
      console.log("Found store count: ", value);
      this.model.balance = value.valueOf();
    }).catch(function (e) {
      console.log(e);
      this.setStatus("Error getting balance; see log.");
    });
  };
  */

  refreshStoreOwners() {
    console.log("Refreshing approved store owners");
    this.marketplaceInstance.getApprovedStoreOwners.call().then((value) => {
      console.log("Found approved store owners count: ", value);
      this.model.balance = value.valueOf();
    }).catch(function (e) {
      console.log(e);
      this.setStatus("Error getting balance; see log.");
    });
  };


/*
    this.metaCoinInstance.getBalance.call(this.model.account).then((value) => {
      console.log("Found balance: ", value);
      this.model.balance = value.valueOf();
    }).catch(function (e) {
      console.log(e);
      this.setStatus("Error getting balance; see log.");
    });
  };
*/


  clickAddress(e) {
    this.model.account = e.target.value;
    //this.refreshBalance();
  }

  setAmount(e) {
    console.log("Setting amount: " + e.target.value);
    this.model.amount = e.target.value;
  }

  setReceiver(e) {
    console.log("Setting receiver: " + e.target.value);
    this.model.receiver = e.target.value;
  }


}
