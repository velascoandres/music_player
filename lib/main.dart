import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audio_player_model.dart';
import 'package:music_player/src/pages/music_player_page.dart';
import 'package:music_player/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusLight();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new AudioPlayerModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: MusicPlayerPage(),
      ),
    );
  }
}
