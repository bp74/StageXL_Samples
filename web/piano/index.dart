library piano;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/karaoke.dart';
part 'source/piano.dart';
part 'source/piano_event.dart';
part 'source/piano_key.dart';
part 'source/songs.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  //------------------------------------------------------------------
  // Initialize the Display List
  //------------------------------------------------------------------

  stage = new Stage(html.querySelector('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  //------------------------------------------------------------------
  // Load images and sounds
  //------------------------------------------------------------------

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager = new ResourceManager()
    ..addBitmapData('KeyBlack','images/KeyBlack.png')
    ..addBitmapData('KeyWhite0','images/KeyWhite0.png')
    ..addBitmapData('KeyWhite1','images/KeyWhite1.png')
    ..addBitmapData('KeyWhite2','images/KeyWhite2.png')
    ..addBitmapData('KeyWhite3','images/KeyWhite3.png')
    ..addBitmapData('Finger','images/Finger.png')
    ..addBitmapData('Background','images/Background.jpg');

  var useSoundSprite = true;
  if (useSoundSprite) {
    resourceManager.addSoundSprite('Notes', 'soundsprite/notes.json');
  } else {
    resourceManager.addSound('Cheer','sounds/Cheer.mp3');
    resourceManager.addSound('Note1','sounds/Note1.mp3');
    resourceManager.addSound('Note2','sounds/Note2.mp3');
    resourceManager.addSound('Note3','sounds/Note3.mp3');
    resourceManager.addSound('Note4','sounds/Note4.mp3');
    resourceManager.addSound('Note5','sounds/Note5.mp3');
    resourceManager.addSound('Note6','sounds/Note6.mp3');
    resourceManager.addSound('Note7','sounds/Note7.mp3');
    resourceManager.addSound('Note8','sounds/Note8.mp3');
    resourceManager.addSound('Note9','sounds/Note9.mp3');
    resourceManager.addSound('Note10','sounds/Note10.mp3');
    resourceManager.addSound('Note11','sounds/Note11.mp3');
    resourceManager.addSound('Note12','sounds/Note12.mp3');
    resourceManager.addSound('Note13','sounds/Note13.mp3');
    resourceManager.addSound('Note14','sounds/Note14.mp3');
    resourceManager.addSound('Note15','sounds/Note15.mp3');
    resourceManager.addSound('Note16','sounds/Note16.mp3');
    resourceManager.addSound('Note17','sounds/Note17.mp3');
    resourceManager.addSound('Note18','sounds/Note18.mp3');
    resourceManager.addSound('Note19','sounds/Note19.mp3');
    resourceManager.addSound('Note20','sounds/Note20.mp3');
    resourceManager.addSound('Note21','sounds/Note21.mp3');
    resourceManager.addSound('Note22','sounds/Note22.mp3');
    resourceManager.addSound('Note23','sounds/Note23.mp3');
    resourceManager.addSound('Note24','sounds/Note24.mp3');
    resourceManager.addSound('Note25','sounds/Note25.mp3');
  }

  //------------------------------------------------------------------
  // Once all resources are loaded, setup the stage.
  //------------------------------------------------------------------

  resourceManager.load().then((_) {

    var background = new Bitmap(resourceManager.getBitmapData('Background'));
    stage.addChild(background);

    var piano = new Piano()
      ..x = 120
      ..y = 30
      ..addTo(stage);

    var karaoke = new Karaoke(happyBirthdayNotes, happyBirthdayLyrics, piano);

    html.querySelector('#song-happy-birthday').onClick.listen((e) =>
        karaoke.updateSong(happyBirthdayNotes, happyBirthdayLyrics));

    html.querySelector('#song-hey-jude').onClick.listen((e) =>
        karaoke.updateSong(heyJudeNotes, heyJudeLyrics));

    html.querySelector('#song-star-spangled-banner').onClick.listen((e) =>
        karaoke.updateSong(starSpangledBannerNotes, starSpangledBannerLyrics));

    html.querySelector('#song-you-are-my-sunshine').onClick.listen((e) =>
        karaoke.updateSong(youAreMySunshineNotes, youAreMySunshineLyrics));

    html.querySelector('#startOver').onClick.listen((e) =>
        karaoke.resetSong());
  });
}
