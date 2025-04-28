import { LightningElement, wire, api } from 'lwc';
import qlList from '@salesforce/apex/QuoteLineController.qlList';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: "View", name: "view" },
    { label: "Edit", name: "edit" }
];

const columns = [
    { label: "Product Name", fieldName: 'ProductName' },
    { label: "Sales Price", fieldName: 'UnitPrice' },
    { label: "Quantity", fieldName: 'Quantity' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            menuAlignment: 'right'
        }
    }
];

export default class QuoteLineItemsTable extends NavigationMixin(LightningElement) {
    @api recordId;
    columnList = columns;
    dataList = [];

    @wire(qlList, { quoteId: '$recordId' })
    wiredData({ error, data }) {
        if (data) {
            this.dataList = data.map(row => ({
                ...row,
                ProductName: row.Product2.Name
            }));
            console.log('Data List:', this.dataList);
        } else if (error) {
            console.error('Error:', error);
        }
    }

    // Handle row actions for View and Edit
    handlerowaction(event) {
        const row = event.detail.row;

        if (event.detail.action.name === 'view') {
            try {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view',
                        objectApiName: 'QuoteLineItem'
                    }
                });
            } catch (error) {
                console.error('Navigation Error for View:', error);
            }
        }

        if (event.detail.action.name === 'edit') {
            try {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'edit',
                        objectApiName: 'QuoteLineItem'
                    }
                });
            } catch (error) {
                console.error('Navigation Error for Edit:', error);
            }
        }
    }

    // Add Quote Line functionality
    handleAddQuoteLine() {
        try {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'QuoteLineItem',
                    actionName: 'new'
                },
                state: {
                    defaultFieldValues: `QuoteId=${this.recordId}`
                }
            });
        } catch (error) {
            console.error('Navigation Error for Add New Quote Line:', error);
        }
    }

    // HTML template should have the button for adding a Quote Line
    get hasData() {
        return this.dataList.length > 0;
    }
}