codeunit 50104 "Item Management"
{
    var
        AutoRentLine: Record "Auto Rent Line";
        Auto: Record Auto;
        AutoSetup: Record "Auto Setup";
        ItemJournalLine: Record "Item Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";

    procedure TransferItemsToAuto(Rec: Record "Auto Rent Header")
    begin
        if not Auto.Get(Rec."Car No.") then
            exit;

        Auto.testfield("Location Code");

        AutoSetup.Get();
        AutoSetup.Testfield("Transfer Nos.");

        AutoRentLine.SetRange("Document No.", Rec."No.");
        AutoRentLine.SetRange(Type, AutoRentLine.Type::Item);
        if AutoRentLine.FindSet() then
            repeat
                ItemJournalLine.Init();
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Transfer;
                ItemJournalLine."Document No." := NoSeriesMgt.GetNextNo(AutoSetup."Transfer Nos.", WorkDate(), true);
                ItemJournalLine.Validate("Posting Date", WorkDate());
                ItemJournalLine.Validate("Item No.", AutoRentLine."No.");
                ItemJournalLine.Validate("Location Code", AutoSetup."Items warehouse location code");
                ItemJournalLine.Validate("New Location Code", Auto."Location Code");
                ItemJournalLine.Validate(Quantity, AutoRentLine.Quantity);

                ItemJnlPostLine.RunWithCheck(ItemJournalLine);
            until AutoRentLine.Next() = 0;
    end;

    procedure TransferItemFromAuto(Rec: Record "Auto Rent Header")
    begin
        if not Auto.Get(Rec."Car No.") then
            exit;

        Auto.testfield("Location Code");

        AutoSetup.Get();
        AutoSetup.Testfield("Transfer Nos.");

        AutoRentLine.SetRange("Document No.", Rec."No.");
        AutoRentLine.SetRange(Type, AutoRentLine.Type::Item);
        if AutoRentLine.FindSet() then
            repeat
                ItemJournalLine.Init();
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Transfer;
                ItemJournalLine."Document No." := NoSeriesMgt.GetNextNo(AutoSetup."Transfer Nos.", WorkDate(), true);
                ItemJournalLine.Validate("Posting Date", WorkDate());
                ItemJournalLine.Validate("Item No.", AutoRentLine."No.");
                ItemJournalLine.Validate("Location Code", Auto."Location Code");
                ItemJournalLine.Validate("New Location Code", AutoSetup."Items warehouse location code");
                ItemJournalLine.Validate(Quantity, AutoRentLine.Quantity);

                ItemJnlPostLine.RunWithCheck(ItemJournalLine);
            until AutoRentLine.Next() = 0;
    end;
}