table 50201 "Warehouse Box"
{
    Caption = 'Warehouse Box';
    DataClassification = CustomerContent;
    LookupPageId = "Warehouse Box List";
    DrillDownPageId = "Warehouse Box List";

    fields
    {
        field(1; "Box No."; Code[20])
        {
            Caption = 'Box No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Box No.");
            end;
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Location Code" <> xRec."Location Code" then begin
                    if Status = Status::"In Use" then
                        Error('Cannot change location when box is in use.');
                end;
            end;
        }
        field(3; Status; Enum "Warehouse Box Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Max Weight (kg)"; Decimal)
        {
            Caption = 'Max Weight (kg)';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 2;
        }
        field(6; "Max Volume (cm³)"; Decimal)
        {
            Caption = 'Max Volume (cm³)';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 2;
        }
        field(7; "Current Weight (kg)"; Decimal)
        {
            Caption = 'Current Weight (kg)';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Box Content"."Total Weight" where("Box No." = field("Box No.")));
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(8; "Current Volume (cm³)"; Decimal)
        {
            Caption = 'Current Volume (cm³)';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Box Content"."Total Volume" where("Box No." = field("Box No.")));
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(10; "Whse. Activity No."; Code[20])
        {
            Caption = 'Warehouse Activity No.';
            TableRelation = "Warehouse Activity Header"."No." where(Type = const(Pick));
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Whse. Shipment No."; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            TableRelation = "Warehouse Shipment Header"."No.";
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Assigned Date"; DateTime)
        {
            Caption = 'Assigned Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Shipped Date"; DateTime)
        {
            Caption = 'Shipped Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Box No.")
        {
            Clustered = true;
        }
        key(LocationStatus; "Location Code", Status)
        {
        }
        key(WhseActivity; "Whse. Activity No.")
        {
        }
        key(WhseShipment; "Whse. Shipment No.")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created Date" := Today;
        "Created By" := CopyStr(UserId, 1, MaxStrLen("Created By"));
        Status := Status::Available;
    end;

    trigger OnDelete()
    var
        WhseBoxContent: Record "Warehouse Box Content";
    begin
        if Status <> Status::Available then
            Error('Cannot delete box with status %1. Only available boxes can be deleted.', Status);

        WhseBoxContent.SetRange("Box No.", "Box No.");
        WhseBoxContent.DeleteAll(true);
    end;

    procedure AssignToPick(WhseActivityNo: Code[20])
    begin
        if Rec."Whse. Activity No." <> WhseActivityNo then
            Rec.TestField(Status, Status::Available);

        Rec.Validate("Whse. Activity No.", WhseActivityNo);
        Rec.Validate(Status, Status::"In Use");
        Rec.Validate("Assigned Date", CurrentDateTime);
        Rec.Modify(true);
    end;

    procedure ShipBox()
    begin
        Rec.TestField(Status, Status::"In Use");
        Rec.Validate(Status, Status::Shipped);
        Rec.Validate("Shipped Date", CurrentDateTime);
        Rec.Modify(true);
    end;

    procedure CheckCapacity(AddWeight: Decimal; AddVolume: Decimal): Boolean
    var
        CurrentWeightValue: Decimal;
        CurrentVolumeValue: Decimal;
    begin
        if ("Max Weight (kg)" = 0) and ("Max Volume (cm³)" = 0) then
            exit(true);

        CalcFields("Current Weight (kg)", "Current Volume (cm³)");
        CurrentWeightValue := "Current Weight (kg)";
        CurrentVolumeValue := "Current Volume (cm³)";

        if ("Max Weight (kg)" > 0) and ((CurrentWeightValue + AddWeight) > "Max Weight (kg)") then
            exit(false);

        if ("Max Volume (cm³)" > 0) and ((CurrentVolumeValue + AddVolume) > "Max Volume (cm³)") then
            exit(false);

        exit(true);
    end;
}
