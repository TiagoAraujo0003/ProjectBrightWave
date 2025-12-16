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
}