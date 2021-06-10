import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audio_player_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          Column(
            children: [
              CustomAppBar(),
              _DiscDuration(),
              _Title(),
              Expanded(child: _Lyrics())
            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics().map(
      (String line) {
        return Text(
          line,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withOpacity(0.6),
          ),
        );
      },
    ).toList();

    return Container(
      child: ListWheelScrollView(
        itemExtent: 42,
        physics: BouncingScrollPhysics(),
        diameterRatio: 1.5,
        children: lyrics,
      ),
    );
  }
}

class _Title extends StatefulWidget {
  const _Title({
    Key? key,
  }) : super(key: key);

  @override
  __TitleState createState() => __TitleState();
}

class __TitleState extends State<_Title> with SingleTickerProviderStateMixin {
  bool isPLaying = false;
  bool firstTime = true;
  late AnimationController playAnimation;
  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    this.isPLaying = false;
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    this.assetAudioPlayer.open(
          Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
        );
    this.assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.currentDuration = duration;
    });

    this.assetAudioPlayer.current.listen((playlable) {
      if (playlable?.audio != null) {
        audioPlayerModel.songDuration = playlable!.audio.duration;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 40),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far Away',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '-Breaking Benjamin-',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayer =
                  Provider.of<AudioPlayerModel>(context, listen: false);

              if (this.isPLaying) {
                this.playAnimation.reverse();
                this.isPLaying = false;
                audioPlayer.controller.stop();
              } else {
                this.playAnimation.forward();
                this.isPLaying = true;
                audioPlayer.controller.repeat();
              }

              if (this.firstTime) {
                this.open();
                this.firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              progress: playAnimation,
              icon: AnimatedIcons.play_pause,
            ),
          )
        ],
      ),
    );
  }
}

class _DiscDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 70),
      child: Row(
        children: [
          _Disc(),
          SizedBox(width: 40),
          _ProgressBar(),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white.withOpacity(0.4));

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final songPercent = audioPlayerModel.songPercent;


    return Container(
      child: Column(
        children: [
          Text('${audioPlayerModel.songTotalDuration}', style: textStyle),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: 3,
                height: 230,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * songPercent,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('${audioPlayerModel.totalCurrentDuration}', style: textStyle),
        ],
      ),
    );
  }
}

class _Disc extends StatelessWidget {
  const _Disc({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              animate: false,
              child: Image(image: AssetImage('assets/aurora.jpg')),
              duration: Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) =>
                  audioPlayer.controller = animationController,
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Color(0xff1C1C25),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
    );
  }
}
