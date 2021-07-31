codeunit 50102 "Release Auto Rent Header"
{
    procedure PerformManualRelease(var AutoRentHeader: Record "Auto Rent Header")
    var
        AutoRentLine: Record "Auto Rent Line";
    begin
        if AutoRentHeader.Status = AutoRentHeader.Status::Released then
            exit;

        AutoRentHeader.TestField("No.");
        AutoRentHeader.TestField("Customer No.");
        AutoRentHeader.TestField("Posting Date");
        AutoRentHeader.TestField("Car No.");
        AutoRentHeader.TestField("Start Date");
        AutoRentHeader.TestField("End Date");
        AutoRentHeader.TestField("Driver License");

        AutoRentHeader.Status := AutoRentHeader.Status::Released;
        AutoRentHeader.Modify(true);

        AutoRentLine.SetRange("Document No.", AutoRentHeader."No.");
        if (AutoRentLine.FindSet()) then begin
            repeat
                AutoRentLine.TestField("No.");
                AutoRentLine.TestField(Quantity);
            until AutoRentLine.Next() = 0;
        end;
    end;

    procedure PerformManualReOpen(var AutoRentHeader: Record "Auto Rent Header")
    var
        AutoRentLine: Record "Auto Rent Line";
    begin
        if AutoRentHeader.Status = AutoRentHeader.Status::Open then
            exit;

        AutoRentHeader.Status := AutoRentHeader.Status::Open;
        AutoRentHeader.Modify(true);
    end;

}