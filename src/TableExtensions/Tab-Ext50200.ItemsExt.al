tableextension 50200 "Items Ext" extends Item
{
    fields
    {
        field(50200; ProdCat; Text[50])
        {
            Caption = 'Product Category';
        }
        field(50201; Brand; Text[50])
        {
        }
        field(50202; CertificateNo; Code[8]) //Fazer trigger para validar
        {
        }
        field(50203; CertExpireDate; Date)
        {
        }
        field(50204; CertModifiedBy; Code[50])
        {
            Caption = 'Certificate Modified By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50205; CertModifiedDate; Date)
        {
            Caption = 'Certificate Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    trigger OnBeforeModify()
    var
        OldItem: Record Item;
    begin
        OldItem.Get(Rec."No.");
        if Rec.CertificateNo <> OldItem.CertificateNo then begin
            Rec.CertModifiedBy := CopyStr(UserId, 1, 50);
            Rec.CertModifiedDate := Today;
        end;
    end;
}

