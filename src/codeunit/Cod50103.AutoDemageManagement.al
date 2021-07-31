codeunit 50103 "Auto Demage Management"
{
    procedure OpenDemageList(var Auto: Record Auto)
    var
        AutoDemage: Record "Auto Demage";
        AutoDemageList: Page "Auto Demage List";
    begin
        AutoDemage.SetRange("Car No.", Auto."No.");
        AutoDemageList.SetTableView(AutoDemage);
        AutoDemageList.RunModal();
    end;

    procedure OpenActiveDemageList(var Auto: Record Auto)
    var
        AutoDemage: Record "Auto Demage";
        AutoDemageList: Page "Auto Demage List";
    begin
        AutoDemage.SetRange("Car No.", Auto."No.");
        AutoDemage.SetRange(Status, AutoDemage.Status::Active);
        AutoDemageList.SetTableView(AutoDemage);
        AutoDemageList.RunModal();
    end;
}