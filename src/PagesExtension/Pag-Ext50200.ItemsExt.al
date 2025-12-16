pageextension 50200 "Items Ext" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(ProdCat; Rec.ProdCat)
            {
                ApplicationArea = All;
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field(CertificateNo; Rec.CertificateNo)
            {
                ApplicationArea = All;
            }
            field(CertExpireDate; Rec.CertExpireDate)
            {
                ApplicationArea = All;
            }
        }
    }
}