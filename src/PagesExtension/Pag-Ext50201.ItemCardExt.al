pageextension 50202 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(Item)
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

                trigger OnValidate()
                var
                    BrightWaveCode: Codeunit "BrightWave Code";
                begin
                    BrightWaveCode.VerifyCertiNo(Rec.CertificateNo);
                end;
            }
            field(CertExpireDate; Rec.CertExpireDate)
            {
                ApplicationArea = All;
                caption = 'Certificate Expiring Date';
            }
        }
    }
}