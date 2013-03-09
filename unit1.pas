unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, ComCtrls, Buttons;

type
  TMySTRList = class( TStringList )
  public
    Modified : Boolean;
    FileName : string;
  end;

  { TMainForm }

  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    VisitHomepageLabel: TLabel;
    NewStoryButton: TButton;
    Panel2: TPanel;
    SaveStoryButton: TButton;
    CopyToClipboardButton: TButton;
    StoryModeCombo: TComboBox;
    WordListSelector: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Label3: TLabel;
    StoryMemo: TMemo;
    WordListMemo: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    WordPanel: TPanel;
    Panel3: TPanel;
    SaveStoryDiag: TSaveDialog;
    ShowWordsButton: TSpeedButton;
    SaveChangesButton: TSpeedButton;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet12: TTabSheet;
    procedure NewStoryButtonClick(Sender: TObject);
    procedure SaveStoryButtonClick(Sender: TObject);
    procedure CopyToClipboardButtonClick(Sender: TObject);
    procedure SaveChangesButtonClick(Sender: TObject);
    procedure VisitHomepageLabelClick(Sender: TObject);
    procedure WordListMemoChange(Sender: TObject);
    procedure WordListSelectorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WordPanelResize(Sender: TObject);
    procedure ShowWordsButtonClick(Sender: TObject);
  private
    { private declarations }
    rAdjectives      : TMySTRList;
    rAmbush          : TMySTRList;
    rCheat           : TMySTRList;
    rDestroy         : TMySTRList;
    rFinally         : TMySTRList;
    rFlee            : TMySTRList;
    rHeros           : TMySTRList;
    rHideouts        : TMySTRList;
    rImprison        : TMySTRList;
    rIntros          : TMySTRList;
    rKidnap          : TMySTRList;
    rKill            : TMySTRList;
    rMindControl     : TMySTRList;
    rMindControlEnd  : TMySTRList;
    rObjects         : TMySTRList;
    rOneDay          : TMySTRList;
    rRelatives       : TMySTRList;
    rRescue          : TMySTRList;
    rVillains        : TMySTRList;
    rWeapons         : TMySTRList;

    rCurrentWordList : TMySTRList;
    rInternalListChange : Boolean;

    rApplicationPath: string;

    rTitle          : string;

    function rGetArticle( aWord : string ) : string;
    function rLoadTextFile( var aList : TMySTRList; aFileName : string ) : Boolean;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  story : TStringList;
  title : string;

implementation

{$R *.lfm}

{ TMainForm }

// Name       : rGetArticle
// Parameters : aWord (string) = The word to determine the articel from
// Discription: Determines the article of a word based on vowels at the beginning
function TMainForm.rGetArticle ( aWord : string ) : string;
var
  lTmpWord : string;
begin
  result := 'a';
  if Length( aWord ) < 1 then Exit;
  lTmpWord := LowerCase( aWord );
  if lTmpWord[1] in [ 'a', 'e', 'i', 'o', 'u' ] then result := 'an';
end;

// Name       : WordPanelResize
// Discription: Makes sure the "ShowWordsButton" is displayed, if the width is
//              below 30 pixels. This is most likely the point where the panel
//              snaps and is invisible.
procedure TMainForm.WordPanelResize(Sender: TObject);
begin
  ShowWordsButton.Visible := WordPanel.Width < 30;
end;

// Name       : ShowWordsButtonClick
// Discription: Displays the WordPanel by setting it's width to a value where
//              it doesn't snap and is clearly visible.
procedure TMainForm.ShowWordsButtonClick(Sender: TObject);
begin
  WordPanel.Width := 150;
end;

// Name       : NewStoryButtonClick
// Discription: Creates a new story and displays it in the StoryMemo
procedure TMainForm.NewStoryButtonClick(Sender: TObject);
var
  lPlot          : TStringList;
  lPlotEnds      : TStringList;
  lPlotLine      : TStringList;
  lStory         : TStringList;

  lPlotMode      : Integer;

  // Story Configuration
  lIntro         : string;
  lOneDay        : string;
  lFinal         : string;

  lHeroName      : string;
  lHeroAdjective : string;
  lHeroGender    : string;  // He / She
  lHeroGender2   : string;  // His / Her

  lVillain       : string;
  lHideout       : string;

  lAmbush        : string;
  lCheat         : string;
  lDestroy       : string;
  lWitchEnd      : string;
  lFlee          : string;
  lImprison      : string;
  lKidnap        : string;
  lKill          : string;
  lRescue        : string;
  lWitch         : string;

  lObject        : string;
  lVictim        : string;
  lWeapon        : string;

  lGenders       : array [ 0..1 ] of string;

  lAddLine       : Boolean;
begin
  // Prepare all local lists
  lPlot     := TStringList.Create;
  lPlotEnds := TStringList.Create;
  lPlotLine := TStringList.Create;
  lStory    := TStringList.Create;

  // Add all Plot Endings
  lPlotEnds.Add( 'flee' );
  lPlotEnds.Add( 'imprison' );
  lPlotEnds.Add( 'kill' );
  lPlotEnds.Add( 'kill_weapon' );

  lPlotMode      := StoryModeCombo.ItemIndex;

  lGenders[ 0 ] := 'He';
  lGenders[ 1 ] := 'She';

  // Configure the story
    // Configure time events
  lIntro  := rIntros.Strings[ Random( rIntros.Count ) ];
  lOneDay := rOneDay.Strings[ Random( rOneday.Count ) ];
  lFinal  := rFinally.Strings[ Random( rFinally.Count ) ];

    // Configure the hero
  lHeroName      := rHeros.Strings[ Random( rHeros.Count ) ];
  lHeroAdjective := rAdjectives.Strings[ Random( rAdjectives.Count ) ];
  lHeroGender    := lGenders[ Random( 2 ) ];
  lHeroGender2   := 'his';
  if lHeroGender = 'She' then lHeroGender2 := 'her';

    // Configure the villain
  lVillain := rVillains.Strings[ Random( rVillains.Count ) ];
  lHideout := rHideouts.Strings[ Random( rHideouts.Count ) ];

    // Configure the actions
  lAmbush   := rAmbush.Strings[ Random( rAmbush.Count ) ];
  lCheat    := rCheat.Strings[ Random( rCheat.Count ) ];
  lDestroy  := rDestroy.Strings[ Random( rDestroy.Count ) ];
  lWitchEnd := rMindControlEnd.Strings[ Random( rMindControlEnd.Count ) ];
  lFlee     := rFlee.Strings[ Random( rFlee.Count ) ];
  lImprison := rImprison.Strings[ Random( rImprison.Count ) ];
  lKidnap   := rKidnap.Strings[ Random( rKidnap.Count ) ];
  lKill     := rKill.Strings[ Random( rKill.Count ) ];
  lRescue   := rRescue.Strings[ Random( rRescue.Count ) ];
  lWitch    := rMindControl.Strings[ Random( rMindControl.Count ) ];

    // Configure the victims
  lObject := rObjects.Strings[ Random( rObjects.Count ) ];
  lVictim := rRelatives.Strings[ Random( rRelatives.Count ) ];
  lWeapon := rWeapons.Strings[ Random( rWeapons.Count ) ];

  try

    // Choose a random plot if it's set to "All stories"
    if lPlotMode = 0 then lPlotMode := Random( StoryModeCombo.Items.Count - 1 ) + 1;

    // Add the intro
    lPlot.Add( 'intro' );

    // Determine the plot and it's starting point
    case lPlotMode of
      // 1 = Destroy
      // 2 = Kidnap (Hero)
      // 3 = Kidnap (Relative)
      // 4 = Mind Control
      // 5 = Revenge

      1:
      begin
        lPlot.Add( 'destroy' );
        if Random( 100 ) > 50 then lPlot.Add( 'cheat' );
      end;

      2:
      begin
        lPlot.Add( 'kidnap_hero' );
        if Random( 100 ) > 50 then lPlot.Add( 'cheat' );
      end;

      3:
      begin
        lPlot.Add( 'kidnap_victim' );
        if Random( 100 ) >= 50 then lPlot.Add( 'ambush_hideout' );
        if Random( 100 ) >= 50 then lPlot.Add( 'cheat' );
        lPlot.Add( 'rescue_victim' );
      end;

      4:
      begin
        lPlot.Add( 'witch' );
        lPlot.Add( 'cheat' );
        lPlot.Add( 'entwitch' );
      end;

      5:
      begin
        lPlot.Add( 'revenge' );
        if Random( 100 ) > 50 then lPlot.Add( 'cheat' );
      end;

    end;

    // Add an ending
    lPlot.Add( lPlotEnds.Strings[ Random( lPlotEnds.Count ) ] );

    StoryMemo.Lines.Text := '';

    // Run this loop as long as there is a plotline to manage
    while lPlot.Count > 0 do
    begin

      lAddLine := False; // To prevent bugs: Add only when a plotline has been selected
      lPlotLine.Clear;

      if lPlot.Strings[ 0 ] = 'ambush_hideout' then
      begin
        lPlotLine.Add( Format( 'The %s %s the % of the %s.',  [ lHeroName, lAmbush, lHideout, lVillain ] ) );
        lPlotLine.Add( Format( '%s %s the %s of the %s.', [ lHeroGender, lAmbush, lHideout, lVillain ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'intro' then
      begin
        lPlotLine.Add( Format( '%s there lived %s %s.',  [ lIntro, rGetArticle( lHeroName ), lHeroName ] ) );
        lPlotLine.Add( Format( '%s there was %s %s %s.', [ lIntro, rGetArticle( lHeroAdjective ), lHeroAdjective, lHeroName ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'cheat' then
      begin
        lPlotLine.Add( Format( '%s %s the %s.', [ lHeroGender, lCheat, lVillain ] ) );
        lPlotLine.Add( Format( 'The %s %s the %s.', [ lHeroName, lCheat, lVillain ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'destroy' then
      begin
        lPlotLine.Add( Format( '%s %s %s %s the %s of the %s.', [ lOneDay, rGetArticle( lVillain ), lVillain, lDestroy, lObject, lHeroName ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'entwitch' then
      begin
        lPlotLine.Add( Format( 'The %s %s the %s.', [ lVillain, lWitchEnd, lHeroName ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'flee' then
      begin
        lPlotLine.Add( Format( '%s %s %s.'    , [ lFinal, LowerCase( lHeroGender ), lFlee ] ) );
        lPlotLine.Add( Format( '%s the %s %s.', [ lFinal, lHeroName, lFlee ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'imprison' then
      begin
        lPlotLine.Add( Format( '%s %s %s the %s.', [ lFinal, LowerCase( lHeroGender ), lImprison, lVillain ] ) );
        lPlotLine.Add( Format( '%s the %s %s the %s.', [ lFinal, lHeroName, lImprison, lVillain ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'kidnap_hero' then
      begin
        lPlotLine.Add( Format( '%s %s was %s by %s %s.', [ lOneDay, LowerCase( lHeroGender ), lKidnap, rGetArticle( lVillain ), lVillain ] ) );
        lPlotLine.Add( Format( '%s the %s was %s by %s %s.', [ lOneDay, lHeroName, lKidnap, rGetArticle( lVillain ), lVillain ] ) );
        lAddLine := true;
      end;


      if lPlot.Strings[ 0 ] = 'kidnap_victim' then
      begin
        lPlotLine.Add( Format( '%s the %s of the %s was %s by %s %s.', [ lOneDay, lVictim, lHeroName, lKidnap, rGetArticle( lVillain ), lVillain ] ) );
        lPlotLine.Add( Format( '%s %s %s was %s by %s %s.', [ lOneDay, lHeroGender2, lVictim, lKidnap, rGetArticle( lVillain ), lVillain ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'kill' then
      begin
        lPlotLine.Add( Format( '%s %s %s the %s.', [ lFinal, LowerCase( lHeroGender ), lKill, lVillain ] ) );
        lPlotLine.Add( Format( '%s the %s %s the %s.', [ lFinal, lHeroName, lKill, lVillain ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'kill_weapon' then
      begin
        lPlotLine.Add( Format( '%s %s %s the %s with %s %s.', [ lFinal, LowerCase( lHeroGender ), lKill, lVillain, rGetArticle( lWeapon ), lWeapon ] ) );
        lPlotLine.Add( Format( '%s the %s %s the %s with %s %s.', [ lFinal, lHeroName, lKill, lVillain, rGetArticle( lWeapon ), lWeapon ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'rescue_victim' then
      begin
        lPlotLine.Add( Format( 'The %s %s %s %s from the %s.', [ lHeroName, lRescue, lHeroGender2, lVictim, lVillain ] ) );
        lPlotLine.Add( Format( '%s %s %s %s from the %s.', [ lHeroGender, lRescue, lHeroGender2, lVictim, lVillain ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'revenge' then
      begin
        lPlotLine.Add( Format( '%s %s %s %s the %s of the %s.', [ lOneDay, rGetArticle( lVillain ), lVillain, lKill, lVictim, lHeroName ] ) );
        lPlotLine.Add( Format( '%s %s %s %s %s %s.', [ lOneDay, rGetArticle( lVillain ), lVillain, lKill, lHeroGender2, lVictim ] ) );
        lAddLine := true;
      end;

      if lPlot.Strings[ 0 ] = 'witch' then
      begin
        lPlotLine.Add( Format( '%s %s was %s by %s %s.', [ lOneDay, LowerCase( lHeroGender ), lWitch, rGetArticle( lVillain ), lVillain ] ) );
        lPlotLine.Add( Format( '%s the %s was %s by %s %s.', [ lOneDay, lHeroName, lWitch, rGetArticle( lVillain ), lVillain ] ) );
        lAddLine := true;
      end;

      // Add a random line
      if lAddLine then lStory.Add( lPlotLine.Strings[ Random( lPlotLine.Count ) ] ); // Choose one of the avaible story lines
      lPlot.Delete( 0 ); // Remove the current Plotline from the list
    end;

    // Show the story in the StoryMemo
    StoryMemo.Lines.AddStrings( lStory );

  finally
    // The lists became useless. Delete them!
    lPlot.Free;
    lPlotEnds.Free;
    lPlotLine.Free;
    lStory.Free;
  end;

  // Creating a title
  case Random( 4 ) of
    0: rTitle := Format( 'The %s', [ lVillain ] );
    1: rTitle := Format( 'The %s and the %s', [ lHeroName, lVillain ] );
    2: rTitle := Format( 'The %s %s', [ lHeroAdjective, lHeroName ] );
    3:
    begin
      case lPlotMode of
        // 1 = Destroy
        // 2 = Kidnap (Hero)
        // 3 = Kidnap (Relative)
        // 4 = Mind Control
        // 5 = Revenge
        1: rTitle := Format( 'The %s %s', [ lDestroy, lObject ] );
        2: rTitle := Format( 'The %s %s', [ lKidnap, lHeroName ] );
        3: rTitle := Format( 'The %s %s', [ lKidnap, lVictim ] );
        4: rTitle := Format( 'The %s %s', [ lWitch, lHeroName ] );
        5: rTitle := Format( 'The %s %s', [ lKill, lVictim] );
      end;
    end;
  end;

  MainForm.Caption := 'Plot Narrator - ' + rTitle;
end;

// Name       : SaveStoryButtonClick
// Discription: Saves the generated story and suggests a possible filename based
//              on the title of the story
procedure TMainForm.SaveStoryButtonClick(Sender: TObject);
var
  lFileName : string;
begin
  SaveStoryDiag.FileName := rTitle; // Use the current title as the filename
  if SaveStoryDiag.Execute then
  begin
    lFileName := SaveStoryDiag.FileName;
    if (SaveStoryDiag.FilterIndex = 1) and ( LowerCase( ExtractFileExt(lFileName) ) <> '.txt' ) then lFileName := lFileName + '.txt'; // Add the TXT if not present (only if mode is .txt)
    WordListMemo.Lines.SaveToFile( lFileName );
  end;
end;

// Name       : rLoadTextFile
// Parameters : - aList ( TMySTRList ) = The target list wich contains the file
//              - aFileName ( string ) = The FileName of the textfile (without path)
// Discription: Loads a textfile into a TMySTRList and sets it's parameters if
//              successull
function TMainForm.rLoadTextFile( var aList : TMySTRList; aFileName : string ) : Boolean;
begin
  Result := True;

  try
    aList.LoadFromFile( rApplicationPath + 'txt/' + aFileName + '.txt' );
  except
    Result := False;
  end;

  // Successfully loaded. Set the filename of this list
  if Result then aList.FileName := rApplicationPath + 'txt/' + aFileName + '.txt';
end;

// Name       : CopyToClipboardButtonClick
// Discription: Copys the content of the StoryMemo into the clipboard
procedure TMainForm.CopyToClipboardButtonClick(Sender: TObject);
begin
  StoryMemo.SelectAll;
  StoryMemo.CopyToClipboard;
end;

// Name       : SaveChangesButtonClick
// Discription: Saves the changes of the list to the stored filename
procedure TMainForm.SaveChangesButtonClick(Sender: TObject);
begin
  rCurrentWordList.SaveToFile( rCurrentWordList.FileName );
  rCurrentWordList.Modified := False;
end;

// Name       : VisitHomepageLabelClick
// Discription: Opens the homepage with th default browser
procedure TMainForm.VisitHomepageLabelClick(Sender: TObject);
begin
  //
end;

// Name       :
// Discription:
procedure TMainForm.WordListMemoChange(Sender: TObject);
begin
  rCurrentWordList.Text     := WordListMemo.Lines.Text;
  if not rInternalListChange then rCurrentWordList.Modified := True;
  if rInternalListChange then WordListMemo.Modified := False;
end;

// Name       :
// Discription:
procedure TMainForm.WordListSelectorChange(Sender: TObject);
var
  lAnswer : Integer;
begin
  rInternalListChange := True;

  if rCurrentWordList.Modified then
  begin
    lAnswer := MessageDlg( 'Content changed', 'The current word list has been modified. Do you want to save them before changing the word list?', mtWarning, [ mbYes, mbNo ], 0 );
    case lAnswer of
      mrYes:
      begin
        rCurrentWordList.SaveToFile( rCurrentWordList.FileName );
        rCurrentWordList.Modified := False;
      end;
    end;
  end;

  if ( WordListSelector.ItemIndex =  0 ) then rCurrentWordList := rAdjectives;
  if ( WordListSelector.ItemIndex =  1 ) then rCurrentWordList := rAmbush;
  if ( WordListSelector.ItemIndex =  2 ) then rCurrentWordList := rCheat;
  if ( WordListSelector.ItemIndex =  3 ) then rCurrentWordList := rDestroy;
  if ( WordListSelector.ItemIndex =  4 ) then rCurrentWordList := rFinally;
  if ( WordListSelector.ItemIndex =  5 ) then rCurrentWordList := rFlee;
  if ( WordListSelector.ItemIndex =  6 ) then rCurrentWordList := rHeros;
  if ( WordListSelector.ItemIndex =  7 ) then rCurrentWordList := rHideouts;
  if ( WordListSelector.ItemIndex =  8 ) then rCurrentWordList := rImprison;
  if ( WordListSelector.ItemIndex =  9 ) then rCurrentWordList := rIntros;
  if ( WordListSelector.ItemIndex = 10 ) then rCurrentWordList := rKidnap;
  if ( WordListSelector.ItemIndex = 11 ) then rCurrentWordList := rKill;
  if ( WordListSelector.ItemIndex = 12 ) then rCurrentWordList := rMindControl;
  if ( WordListSelector.ItemIndex = 13 ) then rCurrentWordList := rMindControlEnd;
  if ( WordListSelector.ItemIndex = 14 ) then rCurrentWordList := rObjects;
  if ( WordListSelector.ItemIndex = 15 ) then rCurrentWordList := rOneDay;
  if ( WordListSelector.ItemIndex = 16 ) then rCurrentWordList := rRelatives;
  if ( WordListSelector.ItemIndex = 17 ) then rCurrentWordList := rRescue;
  if ( WordListSelector.ItemIndex = 18 ) then rCurrentWordList := rVillains;
  if ( WordListSelector.ItemIndex = 19 ) then rCurrentWordList := rWeapons;

  WordListMemo.Lines.Text := rCurrentWordList.Text;
  WordListMemo.Modified   := rCurrentWordList.Modified;

  rInternalListChange := False;
end;

// Name       :
// Discription:
procedure TMainForm.FormCreate(Sender: TObject);
begin
  Randomize;

  rAdjectives      := TMySTRList.Create;
  rAmbush          := TMySTRList.Create;
  rCheat           := TMySTRList.Create;
  rDestroy         := TMySTRList.Create;
  rFinally         := TMySTRList.Create;
  rFlee            := TMySTRList.Create;
  rHeros           := TMySTRList.Create;
  rHideouts        := TMySTRList.Create;
  rImprison        := TMySTRList.Create;
  rIntros          := TMySTRList.Create;
  rKidnap          := TMySTRList.Create;
  rKill            := TMySTRList.Create;
  rMindControl     := TMySTRList.Create;
  rMindControlEnd  := TMySTRList.Create;
  rObjects         := TMySTRList.Create;
  rOneDay          := TMySTRList.Create;
  rRelatives       := TMySTRList.Create;
  rRescue          := TMySTRList.Create;
  rVillains        := TMySTRList.Create;
  rWeapons         := TMySTRList.Create;

  rApplicationPath := ExtractFilePath( Application.ExeName );

  rLoadTextFile( rAdjectives    , 'adjectives' );
  rLoadTextFile( rAmbush        , 'ambush' );
  rLoadTextFile( rCheat         , 'cheat' );
  rLoadTextFile( rDestroy       , 'destroy' );
  rLoadTextFile( rFinally       , 'finally' );
  rLoadTextFile( rFlee          , 'flee' );
  rLoadTextFile( rHeros         , 'heros' );
  rLoadTextFile( rHideouts      , 'hideouts' );
  rLoadTextFile( rImprison      , 'imprison' );
  rLoadTextFile( rIntros        , 'intro' );
  rLoadTextFile( rKidnap        , 'kidnap' );
  rLoadTextFile( rKill          , 'kill' );
  rLoadTextFile( rMindControl   , 'witch' );
  rLoadTextFile( rMindControlEnd, 'witch_end' );
  rLoadTextFile( rObjects       , 'destroyobject' );
  rLoadTextFile( rOneDay        , 'oneday' );
  rLoadTextFile( rRelatives     , 'relative' );
  rLoadTextFile( rRescue        , 'rescue' );
  rLoadTextFile( rVillains      , 'villains' );
  rLoadTextFile( rWeapons       , 'weapons' );

  rInternalListChange := True;
  WordListMemo.Lines.Text := rAdjectives.Text;
  rCurrentWordList := rAdjectives;
  rInternalListChange := False;
end;

// Name       :
// Discription:
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  rAdjectives.Free;
  rAmbush.Free;
  rCheat.Free;
  rDestroy.Free;
  rFinally.Free;
  rFlee.Free;
  rHeros.Free;
  rHideouts.Free;
  rImprison.Free;
  rIntros.Free;
  rKidnap.Free;
  rKill.Free;
  rMindControl.Free;
  rMindControlEnd.Free;
  rObjects.Free;
  rOneDay.Free;
  rRelatives.Free;
  rRescue.Free;
  rVillains.Free;
  rWeapons.Free;
end;

end.

