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
    isMarketplaceAdministrator:0,
    isMarketplaceApprovedStoreOwner:0,
    role:"",
    approvedStoreOwners:[],
    marketplaceAdministrators:[],
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
    this.getMarketplaceAdministrators();
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
      this.setStatus("Error getting role administrator; see log.");
    });


    console.log("Getting role, isapprovedStoreOwner ?");
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.hasRole.call(this.model.account, "marketplaceApprovedStoreOwner",
    {from: this.model.account }).then((value) => {
      console.log("is role marketplaceApprovedStoreOwner ? ", value);
      this.model.isMarketplaceApprovedStoreOwner = value;
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error getting role approvedStoreOwner; see log.");
    });

    this.model.role = "shopper";
    if(Boolean(this.model.isMarketplaceApprovedStoreOwner)==Boolean('true'))this.model.role = "marketplaceApprovedStoreOwner";
    if(Boolean(this.model.isMarketplaceAdministrator)==Boolean('true'))this.model.role = "marketplaceAdministrator";

  };

//<h3>Approved store owners Count : {{this.model.approvedStoreOwners}}</h3>
/*
<head> <script src="angular.js"></script></head>
<body ng-init= "names=['Bob', 'Bill', 'Sarah', 'Robert', 'Sam', 'Jill', 'Dave', 'Larry', 'Jack']">
<ul ng-repeat="firstname in names">
<li>{{firstname}}</li>
</ul>
*/


getMarketplaceAdministrators(){
  if (!this.marketplaceInstance) {
    this.setStatus("marketplace instance is not loaded, unable to send transaction");
    return;
  };

  console.log("Getting administrators");
  this.setStatus("Initiating transaction... (please wait)");
//getStores
//getMarketplaceAdministrators
//getApprovedStoreOwners
  this.marketplaceInstance.getMarketplaceAdministrators.call(
  {from: this.model.account }).then((value) => {
    console.log("administrators ", value);
    this.model.marketplaceAdministrators = value;
  }).catch((e) => {
    console.log(e);
    this.setStatus("Error getting administrators; see log.");
  });

};


  addRoleAdministrator(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    let receiver = this.model.receiver;

    console.log("Approving administrator" + this.model.receiver);
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.addRoleAdministrator(receiver,
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
      this.setStatus("Error adding role administrator; see log.");
    });
  }

  removeRoleAdministrator(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    let receiver = this.model.receiver;
    console.log("Deleting administrator" + this.model.receiver);
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.removeRoleAdministrator(receiver,
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
      this.setStatus("Error removing role administrator; see log.");
    });
  }

  getMarketplaceApprovedStoreOwners(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    console.log("Getting approved stores owners");
    this.setStatus("Initiating transaction... (please wait)");
//getStores
//getMarketplaceAdministrators
//getApprovedStoreOwners
    this.marketplaceInstance.getApprovedStoreOwners.call(
    {from: this.model.account }).then((value) => {
      console.log("approved store owners ", value);
      this.model.approvedStoreOwners = value;
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error getting approved store owners; see log.");
    });

  };


  addApprovedStoreOwner(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    let receiver = this.model.receiver;

    console.log("Approving store owner" + this.model.receiver);
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.addRoleApprovedStoreOwner(receiver,
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
      this.setStatus("Error adding role approved store owner; see log.");
    });
  }


  removeApprovedStoreOwner(){
    if (!this.marketplaceInstance) {
      this.setStatus("marketplace instance is not loaded, unable to send transaction");
      return;
    };

    let receiver = this.model.receiver;
    console.log("Deleting approved store owner" + this.model.receiver);
    this.setStatus("Initiating transaction... (please wait)");

    this.marketplaceInstance.removeRoleApprovedStoredOwner(receiver,
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
      this.setStatus("Error removing approved store owner; see log.");
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
