codeunit 50200 "BrightWave Code"
{
    procedure VerifyCertiNo(Certificate: Code[8])
    var
        i: Integer;
    begin
        if Certificate = '' then
            exit;
        if StrLen(Certificate) = 8 then begin
            for i := 1 to StrLen(Certificate) do begin
                if not (Certificate[i] in ['0' .. '9']) and not (Certificate[i] in ['A' .. 'Z']) then
                    Error('No special characters allowed!');
            end;
        end
        else
            Error('Certificate No. must be 8 characters');
    end;

    procedure GetCertificateChangeLog(ItemNo: Code[20]): Text
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            if (Item.CertModifiedBy <> '') and (Item.CertModifiedDate <> 0D) then
                exit(StrSubstNo('Certificate modified by %1 on %2', Item.CertModifiedBy, Format(Item.CertModifiedDate)))
            else
                exit('');
        end else
            exit('');
    end;
}