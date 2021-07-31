codeunit 50101 "Auto Reservation Management"
{
    procedure OpenReservations(var Auto: Record Auto)
    var
        AutoReservation: Record "Auto Reservation";
        AutoReservationList: Page "Auto Reservation List";
    begin
        AutoReservation.SetRange("Car No.", Auto."No.");
        AutoReservationList.SetTableView(AutoReservation);
        AutoReservationList.RunModal();
    end;

    procedure OpenActiveReservations(var Auto: Record Auto)
    var
        AutoReservation: Record "Auto Reservation";
        AutoReservationList: Page "Auto Reservation List";
    begin
        AutoReservation.SetRange("Car No.", Auto."No.");
        AutoReservationList.SetTableView(AutoReservation);
        AutoReservationList.RunModal();
    end;
}