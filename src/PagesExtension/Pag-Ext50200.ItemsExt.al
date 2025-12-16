pageextension 50200 "Items Ext" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(ProdCat; Rec.ProdCat)
            {
                ApplicationArea = All;
                caption = 'Product Category';
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field(CertificateNo; Rec.CertificateNo)
            {
                ApplicationArea = All;
                caption = 'Certificate No.';
            }
            field(CertExpireDate; Rec.CertExpireDate)
            {
                ApplicationArea = All;
                caption = 'Certificate Expiring Date';
            }
        }
    }
}