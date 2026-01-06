table 50202 "Warehouse Box Content"
{
    Caption = 'Warehouse Box Content';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Box No."; Code[20])
        {
            Caption = 'Box No.';
            TableRelation = "Warehouse Box";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                WhseBox: Record "Warehouse Box";
            begin
                if WhseBox.Get("Box No.") then begin
                    "Location Code" := WhseBox."Location Code";
                    "Whse. Activity No." := WhseBox."Whse. Activity No.";
                    "Whse. Shipment No." := WhseBox."Whse. Shipment No.";
                end;
            end;
        }
        field(3; "Whse. Activity No."; Code[20])
        {
            Caption = 'Warehouse Activity No.';
            TableRelation = "Warehouse Activity Header"."No." where(Type = const(Pick));
            DataClassification = CustomerContent;
        }
        field(4; "Whse. Activity Line No."; Integer)
        {
            Caption = 'Warehouse Activity Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Whse. Shipment No."; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            TableRelation = "Warehouse Shipment Header"."No.";
            DataClassification = CustomerContent;
        }
        field(6; "Whse. Shipment Line No."; Integer)
        {
            Caption = 'Warehouse Shipment Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(12; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(13; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
        }
        field(14; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
        }
        field(20; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Qty. to Handle" := Quantity;
                UpdateWeightVolume();
            end;
        }
        field(21; "Qty. to Handle"; Decimal)
        {
            Caption = 'Qty. to Handle';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if "Qty. to Handle" > Quantity then
                    Error('Qty. to Handle cannot be greater than Quantity.');
                UpdateWeightVolume();
            end;
        }
        field(22; "Qty. Handled"; Decimal)
        {
            Caption = 'Qty. Handled';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(30; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight (kg)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(31; "Total Volume"; Decimal)
        {
            Caption = 'Total Volume (cm³)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(40; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(41; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            DataClassification = CustomerContent;
        }
        field(42; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
        }
        field(43; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            DataClassification = CustomerContent;
        }
        field(50; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
            DataClassification = CustomerContent;
        }
        field(60; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(61; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(BoxNo; "Box No.")
        {
        }
        key(WhseActivity; "Whse. Activity No.", "Whse. Activity Line No.")
        {
        }
        key(WhseShipment; "Whse. Shipment No.", "Whse. Shipment Line No.")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created Date" := CurrentDateTime;
        "Created By" := CopyStr(UserId, 1, MaxStrLen("Created By"));
    end;

    local procedure UpdateWeightVolume()
    var
        Item: Record Item;
    begin
        if not Item.Get("Item No.") then
            exit;

        "Total Weight" := "Qty. to Handle" * Item."Net Weight";
        "Total Volume" := "Qty. to Handle" * Item."Unit Volume";
    end;

    procedure ValidateBoxCapacity(): Boolean
    var
        WhseBox: Record "Warehouse Box";
    begin
        if not WhseBox.Get("Box No.") then
            exit(false);

        exit(WhseBox.CheckCapacity("Total Weight", "Total Volume"));
    end;
}
