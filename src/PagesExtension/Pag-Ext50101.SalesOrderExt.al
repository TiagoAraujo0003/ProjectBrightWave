pageextension 50203 "Sales Order Ext" extends "Sales invoice"
{
    layout
    {
    }
    actions
    {
        addfirst(processing)
        {
            action("Safety Certificate")
            {
                ApplicationArea = All;
                Caption = 'Safety Certificate';
                ToolTip = 'Create Safety Certificate';
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = report "Certificate";

                trigger OnAction()
                var
                    SafetyCert: Record "Certificate";
                    CertNo: Code[50];
                begin
                    // Validar que a ordem tem número
                    if Rec."No." = '' then begin
                        Message('Sales Order must be saved first.');
                        exit;
                    end;

                    // Verificar se já existe certificado
                    SafetyCert.Reset();
                    SafetyCert.SetRange("Sales Order No.", Rec."No.");

                    if SafetyCert.IsEmpty() then begin
                        // Criar novo certificado
                        SafetyCert.Init();
                        SafetyCert."Sales Order No." := Rec."No.";
                        SafetyCert."Customer No." := Rec."Bill-to Customer No.";
                        SafetyCert."Customer Name" := Rec."Bill-to Name";
                        SafetyCert."Date of Sale" := Today();
                        CertNo := Rec."No." + '-' + Format(Today(), 0, '<Day,2>-<Month,2>-<Year4>');
                        SafetyCert."Certificate No." := CertNo;
                        SafetyCert."Valid To" := CalcDate('<+1Y>', Today());
                        SafetyCert.Insert(true);
                    end;
                end;
            }
        }
    }
}