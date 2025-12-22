pageextension 50202 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Base Unit of Measure")
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
        }
        addafter("Item Category Code")
        {
            field(CertificateNo; Rec.CertificateNo)
            {
                ApplicationArea = All;
                caption = 'Certificate No.';

                trigger OnValidate()
                var
                    BrightWaveCode: Codeunit "BrightWave Code";
                begin
                    BrightWaveCode.VerifyCertiNo(Rec.CertificateNo);
                    CertificateChangeInfo := GetCertificateChangeInfo();
                    CurrPage.Update(false);
                end;
            }
            field(CertExpireDate; Rec.CertExpireDate)
            {
                ApplicationArea = All;
                caption = 'Certificate Expiring Date';
            }
            field(CertificateChangeInfo; CertificateChangeInfo)
            {
                ApplicationArea = All;
                Caption = '';
                ShowCaption = false;
                Editable = false;
                Style = Subordinate;
                StyleExpr = true;
            }
        }
    }

    var
        CertificateChangeInfo: Text;

    trigger OnAfterGetRecord()
    begin
        CertificateChangeInfo := GetCertificateChangeInfo();
    end;

    local procedure GetCertificateChangeInfo(): Text
    var
        BrightWaveCode: Codeunit "BrightWave Code";
    begin
        exit(BrightWaveCode.GetCertificateChangeLog(Rec."No."));
    end;
}