import { LightningElement, api } from "lwc";
import ibanValidate from "@salesforce/apex/IBANValidation.ibanValidate";
import { getRecordNotifyChange } from "lightning/uiRecordApi";

export default class IbanValidation extends LightningElement {
  @api recordId;
  @api ibanStatus;
  @api ibanNumber;
  error;

  verifyIban(event) {
    let ibanNumberValue = this.template.querySelector(
      "lightning-input-field[data-id=input1]"
    ).value;
    console.log("this.ibanNumber=", ibanNumberValue); //'$ibanNumber'
    ibanValidate({ ibanNumber: ibanNumberValue })
      .then((result) => {
        this.ibanStatus = result;
        console.log("this.ibanStatus =", this.ibanStatus);
        getRecordNotifyChange([{ ibanStatus: this.ibanStatus }]);
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.ibanStatus = "In progress";
        console.log("error=", error);
      })
      .finally(() => {
        this.handleSubmit(event);
        //const fields = event.detail.fields;
        // console.log('.finally event ' + JSON.stringify(event.detail.fields));
        //fields.IBAN_Status__c = 'In progress';//this.ibanNumber;
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
      });
  }

  handleSubmit(event) {
    console.log(
      "before event recordEditForm " + JSON.stringify(event.detail.fields)
    );

    event.preventDefault(); // stop the form from submitting
    const fields = event.detail.fields;
    //console.log('onsubmit event recordEditForm ' + JSON.stringify(event.detail.fields));
    // fields.IBAN_Status__c = 'In progress';//this.ibanNumber;
    this.template.querySelector("lightning-record-edit-form").submit(fields);
  }

  handleSuccess(event) {
    const payload = event.detail;
    // console.log(JSON.stringify(payload));
  }
}
