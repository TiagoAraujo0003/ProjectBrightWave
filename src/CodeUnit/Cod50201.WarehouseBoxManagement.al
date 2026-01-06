codeunit 50201 "Warehouse Box Management"
{
    // Core box management functionality for warehouse pick-to-box feature

    procedure ValidateBoxAssignment(WhseActivityNo: Code[20])
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        MissingBoxErr: Label 'Place line %1 for Item %2 does not have a box assigned. All place lines must have boxes before registration.';
    begin
        WhseActivityLine.Reset();
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::Pick);
        WhseActivityLine.SetRange("No.", WhseActivityNo);
        WhseActivityLine.SetRange("Action Type", WhseActivityLine."Action Type"::Place);
        WhseActivityLine.SetFilter("Qty. to Handle", '>0');
        if WhseActivityLine.FindSet() then
            repeat
                if WhseActivityLine."Box No." = '' then
                    Error(MissingBoxErr, WhseActivityLine."Line No.", WhseActivityLine."Item No.");
            until WhseActivityLine.Next() = 0

    end;

    procedure AssignBoxesToPick(var WhseActivityLine: Record "Warehouse Activity Line")
    var
        WhseActivityLine2: Record "Warehouse Activity Line";
        WhseBox: Record "Warehouse Box";
        WhseActivityHeader: Record "Warehouse Activity Header";
        BoxSelectionPage: Page "Warehouse Box List";
        SelectedBoxNo: Code[20];
        LineCount: Integer;
    begin
        if not WhseActivityHeader.Get(WhseActivityLine."Activity Type", WhseActivityLine."No.") then
            exit;

        // Count place lines needing boxes
        WhseActivityLine2.CopyFilters(WhseActivityLine);
        WhseActivityLine2.SetRange("Activity Type", WhseActivityLine."Activity Type"::Pick);
        WhseActivityLine2.SetRange("No.", WhseActivityLine."No.");
        WhseActivityLine2.SetRange("Action Type", WhseActivityLine."Action Type"::Place);
        WhseActivityLine2.SetRange("Box No.", '');
        LineCount := WhseActivityLine2.Count;

        if LineCount = 0 then begin
            Message('All place lines already have boxes assigned.');
            exit;
        end;

        // Setup available boxes
        WhseBox.SetRange("Location Code", WhseActivityHeader."Location Code");
        WhseBox.SetFilter(Status, '%1|%2', WhseBox.Status::Available, WhseBox.Status::"In Use");
        WhseBox.SetFilter("Whse. Activity No.", '%1|%2', '', WhseActivityLine."No.");

        // Allow user to select one box for all lines or assign individually
        if Confirm('Do you want to assign the same box to all %1 unassigned lines?', true, LineCount) then begin
            BoxSelectionPage.SetTableView(WhseBox);
            BoxSelectionPage.LookupMode := true;
            if BoxSelectionPage.RunModal() = Action::LookupOK then begin
                BoxSelectionPage.GetRecord(WhseBox);
                SelectedBoxNo := WhseBox."Box No.";

                if WhseActivityLine2.FindSet() then
                    repeat
                        WhseActivityLine2.Validate("Box No.", SelectedBoxNo);
                        WhseActivityLine2.Modify(true);
                    until WhseActivityLine2.Next() = 0;

                Message('Box %1 assigned to %2 lines.', SelectedBoxNo, LineCount);
            end;
        end else begin
            Message('Please assign boxes manually to each line.');
        end;
    end;

    procedure RegisterPickWithBoxes(var WhseActivityHeader: Record "Warehouse Activity Header")
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        WhseBox: Record "Warehouse Box";
        WhseBoxContent: Record "Warehouse Box Content";
        WhseShptLine: Record "Warehouse Shipment Line";
        Item: Record Item;
    begin
        // Validate all place lines have boxes
        ValidateBoxAssignment(WhseActivityHeader."No.");

        // Create box content entries for each place line
        WhseActivityLine.Reset();
        WhseActivityLine.SetRange("Activity Type", WhseActivityHeader.Type);
        WhseActivityLine.SetRange("No.", WhseActivityHeader."No.");
        WhseActivityLine.SetRange("Action Type", WhseActivityLine."Action Type"::Place);
        WhseActivityLine.SetFilter("Qty. to Handle", '>0');
        if WhseActivityLine.FindSet() then
            repeat
                // Assign box to pick if not already assigned
                WhseBox.Get(WhseActivityLine."Box No.");
                if WhseBox."Whse. Activity No." <> WhseActivityLine."No." then
                    WhseBox.TestField(Status, WhseBox.Status::Available);

                WhseBox.AssignToPick(WhseActivityHeader."No.");

                // Create box content entry
                WhseBoxContent.Init();
                WhseBoxContent."Entry No." := 0;
                WhseBoxContent.Validate("Box No.", WhseActivityLine."Box No.");
                WhseBoxContent.Validate("Whse. Activity No.", WhseActivityLine."No.");
                WhseBoxContent.Validate("Whse. Activity Line No.", WhseActivityLine."Line No.");
                WhseBoxContent.Validate("Location Code", WhseActivityLine."Location Code");
                WhseBoxContent.Validate("Item No.", WhseActivityLine."Item No.");
                WhseBoxContent.Validate("Variant Code", WhseActivityLine."Variant Code");
                WhseBoxContent.Validate("Unit of Measure Code", WhseActivityLine."Unit of Measure Code");
                WhseBoxContent.Validate(Quantity, WhseActivityLine."Qty. to Handle");
                WhseBoxContent.Validate("Qty. to Handle", WhseActivityLine."Qty. to Handle");
                WhseBoxContent.Validate("Bin Code", WhseActivityLine."Bin Code");
                WhseBoxContent.Validate("Source Type", WhseActivityLine."Source Type");
                WhseBoxContent.Validate("Source Subtype", WhseActivityLine."Source Subtype");
                WhseBoxContent.Validate("Source No.", WhseActivityLine."Source No.");
                WhseBoxContent.Validate("Source Line No.", WhseActivityLine."Source Line No.");

                // Get shipment info
                WhseBoxContent.Validate("Whse. Shipment No.", WhseActivityLine."Whse. Document No.");
                if FindWhseShipmentLine(WhseShptLine, WhseActivityLine) then
                    WhseBoxContent.Validate("Whse. Shipment Line No.", WhseShptLine."Line No.");

                // Get item description
                if Item.Get(WhseActivityLine."Item No.") then
                    WhseBoxContent.Validate("Item Description", Item.Description);

                WhseBoxContent.Insert(true);
            until WhseActivityLine.Next() = 0;
    end;

    procedure OnBeforeWhseActivityPost(var WhseActivityHeader: Record "Warehouse Activity Header")
    begin
        if WhseActivityHeader.Type <> WhseActivityHeader.Type::Pick then
            exit;

        ValidateBoxAssignment(WhseActivityHeader."No.");
    end;

    procedure OnAfterWhseActivityPost(var WhseActivityHeader: Record "Warehouse Activity Header")
    begin
        if WhseActivityHeader.Type <> WhseActivityHeader.Type::Pick then
            exit;

        RegisterPickWithBoxes(WhseActivityHeader);
    end;

    procedure OnAfterWhseShipmentPost(var WhseShipmentHeader: Record "Warehouse Shipment Header")
    var
        WhseBox: Record "Warehouse Box";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        WhseBoxContent: Record "Warehouse Box Content";
    begin
        // Mark all boxes as shipped and update posted shipment lines with box numbers
        WhseBox.SetRange("Whse. Shipment No.", WhseShipmentHeader."No.");
        if WhseBox.FindSet() then
            repeat
                WhseBox.ShipBox();
            until WhseBox.Next() = 0;

        // Update posted shipment lines with box info
        PostedWhseShptLine.SetRange("Whse. Shipment No.", WhseShipmentHeader."No.");
        if PostedWhseShptLine.FindSet() then
            repeat
                WhseBoxContent.Reset();
                WhseBoxContent.SetRange("Whse. Shipment No.", WhseShipmentHeader."No.");
                WhseBoxContent.SetRange("Whse. Shipment Line No.", PostedWhseShptLine."Line No.");
                WhseBoxContent.SetRange("Item No.", PostedWhseShptLine."Item No.");
                if WhseBoxContent.FindFirst() then begin
                    PostedWhseShptLine."Box No." := WhseBoxContent."Box No.";
                    PostedWhseShptLine.Modify();
                end;
            until PostedWhseShptLine.Next() = 0;
    end;

    procedure ValidateBoxCapacity(BoxNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
    var
        WhseBox: Record "Warehouse Box";
        Item: Record Item;
        AddWeight: Decimal;
        AddVolume: Decimal;
    begin
        if not WhseBox.Get(BoxNo) then
            exit;

        // Skip if no capacity limits defined
        if (WhseBox."Max Weight (kg)" = 0) and (WhseBox."Max Volume (cm³)" = 0) then
            exit;

        if not Item.Get(ItemNo) then
            exit;

        AddWeight := Quantity * Item."Net Weight";
        AddVolume := Quantity * Item."Unit Volume";

        if not WhseBox.CheckCapacity(AddWeight, AddVolume) then
            Error('Adding %1 units of %2 would exceed the capacity limits of box %3.', Quantity, ItemNo, BoxNo);
    end;

    procedure CreateMultipleBoxes()
    var
        WhseBox: Record "Warehouse Box";
        Location: Record Location;
        LocationPage: Page "Location List";
        StartNo: Integer;
        EndNo: Integer;
        BoxPrefix: Code[10];
        LocationCode: Code[10];
        i: Integer;
    begin
        // Get parameters from user
        LocationPage.LookupMode := true;
        if LocationPage.RunModal() = Action::LookupOK then begin
            LocationPage.GetRecord(Location);
            LocationCode := Location.Code;
        end else
            exit;

        BoxPrefix := 'BOX';
        if not Evaluate(StartNo, '1') then
            exit;
        if not Evaluate(EndNo, '10') then
            exit;

        if not Confirm('Create boxes %1001 to %1010 for location %2?', true, BoxPrefix, BoxPrefix, LocationCode) then
            exit;

        for i := StartNo to EndNo do begin
            WhseBox.Init();
            WhseBox."Box No." := BoxPrefix + Format(i, 0, '<Integer,4><Filler Character,0>');
            WhseBox."Location Code" := LocationCode;
            WhseBox.Description := 'Standard Box ' + Format(i);
            if WhseBox.Insert(true) then;
        end;

        Message('%1 boxes created successfully.', EndNo - StartNo + 1);
    end;

    local procedure FindWhseShipmentLine(var WhseShipmentLine: Record "Warehouse Shipment Line"; WhseActivityLine: Record "Warehouse Activity Line"): Boolean
    begin
        WhseShipmentLine.Reset();
        WhseShipmentLine.SetRange("No.", WhseActivityLine."Whse. Document No.");
        WhseShipmentLine.SetRange("Source Type", WhseActivityLine."Source Type");
        WhseShipmentLine.SetRange("Source Subtype", WhseActivityLine."Source Subtype");
        WhseShipmentLine.SetRange("Source No.", WhseActivityLine."Source No.");
        WhseShipmentLine.SetRange("Source Line No.", WhseActivityLine."Source Line No.");
        exit(WhseShipmentLine.FindFirst());
    end;

    // Integration with standard BC posting
    // Manual integration: Use the custom "Register Pick with Boxes" action on Warehouse Pick page
    // or call the methods in "Warehouse Box Posting Integ." codeunit manually
}
