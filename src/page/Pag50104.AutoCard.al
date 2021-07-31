page 50104 "Auto Card"
{
    Caption = 'Auto Card';
    PageType = Card;
    SourceTable = Auto;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec."No." = '' then
                            Rec."No." := Rec.GetNewAutoNoFromNosSeries();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Mark; Rec.Mark)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field("First Registration Year"; Rec."First Registration Year")
                {
                    ApplicationArea = All;
                }
                field("Insurance to"; Rec."Insurance to")
                {
                    ApplicationArea = All;
                }
                field("Technical Inspection"; Rec."Technical Inspection")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Rent Service"; Rec."Rent Service")
                {
                    ApplicationArea = All;
                }
                field("Rent Price"; Rec."Rent Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(AutoRentHistory)
            {
                Caption = 'Rent History';
                ApplicationArea = All;
                Image = Report;

                trigger OnAction()
                var
                    Auto: Record "Auto";
                    AutoRentHistory: Report "Auto Rent History";
                begin
                    Auto.SetRange("No.", Rec."No.");
                    AutoRentHistory.SetTableView(Auto);
                    AutoRentHistory.RunModal();
                end;
            }
        }
        area(Navigation)
        {
            group(Reservations)
            {
                Caption = 'Reservations';
                action(OpenReservations)
                {
                    Caption = 'Open Reservations';
                    ApplicationArea = All;
                    Image = Open;

                    trigger OnAction()
                    var
                        AutoReservationManagement: Codeunit "Auto Reservation Management";
                    begin
                        AutoReservationManagement.OpenReservations(Rec);
                    end;
                }
                action(OpenActiveReservations)
                {
                    Caption = 'Open Active Reservations';
                    ApplicationArea = All;
                    Image = Open;

                    trigger OnAction()
                    var
                        AutoReservationManagement: Codeunit "Auto Reservation Management";
                    begin
                        AutoReservationManagement.OpenActiveReservations(Rec);
                    end;
                }
            }
            group(Demages)
            {
                Caption = 'Demage';
                action(OpenDemage)
                {
                    Caption = 'Open Demage List';
                    ApplicationArea = All;
                    Image = Open;

                    trigger OnAction()
                    var
                        AutoDemageManagement: Codeunit "Auto Demage Management";
                    begin
                        AutoDemageManagement.OpenDemageList(Rec);
                    end;
                }
                action(OpenActiveDemage)
                {
                    Caption = 'Open Active Demage List';
                    ApplicationArea = All;
                    Image = Open;

                    trigger OnAction()
                    var
                        AutoDemageManagement: Codeunit "Auto Demage Management";
                    begin
                        AutoDemageManagement.OpenActiveDemageList(Rec);
                    end;
                }
            }
        }
    }
}