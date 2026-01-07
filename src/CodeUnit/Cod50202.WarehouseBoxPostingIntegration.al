codeunit 50202 "Warehouse Box Posting Integ."
{
    // This codeunit provides manual integration points for the Warehouse Box feature
    // Use this to call box validation and registration at the right points in your process

    // Example usage in a custom posting routine or page action:
    // 
    // Before registering pick:
    //   WhseBoxPostingInteg.ValidateAndRegisterPick(WhseActivityHeader);
    //
    // After posting shipment:
    //   WhseBoxPostingInteg.FinalizeBoxesOnShipment(WhseShipmentHeader);

    var
        WhseBoxMgt: Codeunit "Warehouse Box Management";

    procedure ValidateAndRegisterPick(var WhseActivityHeader: Record "Warehouse Activity Header")
    begin
        // Validate boxes before registration
        WhseBoxMgt.OnBeforeWhseActivityPost(WhseActivityHeader);

        // Standard registration would happen here (not included)

        // After registration, create box content entries
        WhseBoxMgt.OnAfterWhseActivityPost(WhseActivityHeader);
    end;

    procedure ValidatePickBoxes(WhseActivityNo: Code[20])
    begin
        // Just validate without registering
        WhseBoxMgt.ValidateBoxAssignment(WhseActivityNo);
    end;

    procedure RegisterPickBoxes(var WhseActivityHeader: Record "Warehouse Activity Header")
    begin
        // Create box content entries after pick registration
        WhseBoxMgt.RegisterPickWithBoxes(WhseActivityHeader);
    end;

    procedure FinalizeBoxesOnShipment(var WhseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        // Mark boxes as shipped and update posted lines
        WhseBoxMgt.OnAfterWhseShipmentPost(WhseShipmentHeader);
    end;

    // Example: Custom action on Warehouse Activity page
    // You can add this as a page extension action:
    /*
    action(RegisterWithBoxValidation)
    {
        ApplicationArea = Warehouse;
        Caption = 'Register Pick (with Box Validation)';
        Image = RegisterPick;
        
        trigger OnAction()
        var
            WhseBoxPostingInteg: Codeunit "Warehouse Box Posting Integ.";
            WhseActRegister: Codeunit "Whse.-Activity-Register";
        begin
            // Validate boxes first
            WhseBoxPostingInteg.ValidatePickBoxes(Rec."No.");
            
            // Standard registration
            WhseActRegister.Run(Rec);
            
            // Register boxes
            WhseBoxPostingInteg.RegisterPickBoxes(Rec);
        end;
    }
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterPostWhseShipment', '', false, false)]
    local procedure OnAfterPostWhseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        WhseBoxMgt.OnAfterWhseShipmentPost(WarehouseShipmentHeader);
    end;
}
