import 'package:flutter/material.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reader")),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec facilisis laoreet est, sit amet faucibus eros interdum eu. Suspendisse nisi tellus, tempor in facilisis vel, scelerisque at ligula. Nulla commodo enim tortor, tincidunt facilisis lectus faucibus a. Sed ut molestie orci. Pellentesque aliquam turpis quis interdum efficitur. Donec efficitur tellus condimentum purus ultricies, in porttitor elit porta. Duis porta nibh at ex volutpat, gravida mollis mi accumsan. Fusce accumsan, arcu luctus sagittis cursus, lacus dolor gravida tellus, sed elementum est felis in tellus. Phasellus feugiat est eget quam euismod, eget dapibus mi convallis. Fusce id lobortis velit, ac pretium nibh. Integer vel nisi eget massa porta pellentesque. Vestibulum blandit arcu eu nulla venenatis, in convallis leo congue. Aliquam imperdiet non felis sit amet fringilla. Curabitur sit amet facilisis mi. Praesent id cursus sapien. Suspendisse tincidunt, dui non convallis elementum, quam orci ultrices sem, quis rutrum lorem eros eget quam. Etiam neque augue, lacinia ac interdum vitae, dignissim efficitur sapien. Nullam felis nunc, consectetur ac posuere et, maximus eget nulla. Aenean aliquam dapibus erat id blandit. Pellentesque viverra lacus vel orci bibendum imperdiet. Suspendisse quis nulla a quam placerat sodales vitae ac sem. Pellentesque mauris neque, dictum eu ipsum consectetur, congue laoreet ante. Curabitur molestie nibh quis sodales imperdiet. Nam ornare odio non lectus aliquam, eget facilisis nulla bibendum. Nam ut eros eget tellus aliquet mollis in sit amet orci. Nam bibendum urna augue. Nullam finibus orci id purus vulputate, fringilla viverra eros porta. Etiam maximus sapien interdum ante porta, vitae cursus turpis ultricies. Cras ultricies, ex auctor ullamcorper eleifend, ante lectus placerat tortor, eu vehicula libero massa nec magna. Integer diam mauris, euismod et mattis a, dapibus eu ipsum. Mauris ac luctus diam. Nunc ut nulla placerat, imperdiet est a, semper urna. Integer ut ante eget sem rutrum dictum. Sed eu ex eu augue ultrices volutpat eu sed quam. Nunc sodales suscipit tempus. Aenean ultricies tellus at ex ullamcorper accumsan. Pellentesque et ultricies leo. Fusce varius mauris ipsum, ullamcorper porta felis aliquet vel. Fusce molestie metus at augue lacinia pharetra. Pellentesque faucibus, ante sit amet vehicula venenatis, mauris lectus imperdiet massa, vitae imperdiet augue tortor ut augue. Donec consequat nisi at porta varius. Aenean turpis elit, finibus ac felis non, eleifend sollicitudin neque. Proin rhoncus dapibus nulla, a consequat quam rutrum et. Pellentesque in nisi quis est scelerisque scelerisque. Aenean mollis cursus leo nec consequat. In gravida consequat urna vel mattis. Ut et malesuada nunc. Aenean risus risus, feugiat et arcu a, posuere faucibus risus. Fusce convallis gravida diam vitae gravida. Vivamus interdum porta justo, vitae facilisis arcu ullamcorper nec. Nunc volutpat, lorem id semper porttitor, enim orci viverra nibh, ac ultricies arcu elit ac erat. Pellentesque in erat vel mi rutrum cursus quis in diam. Sed faucibus eu dolor in commodo. Quisque commodo augue eu purus varius mollis. Etiam tristique felis erat, in maximus mi venenatis bibendum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas tincidunt viverra dui quis placerat. In dignissim, nisl eu vestibulum consequat, urna arcu ultrices neque, quis dignissim nisl leo sodales eros. Curabitur at dictum metus, sit amet egestas nunc. In tellus nunc, bibendum non ornare et, vehicula in erat. Nulla cursus dictum fringilla. Phasellus id tortor nisl.",
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[700],
              onPressed: () {},
              shape: CircleBorder(),
              foregroundColor: Colors.white,
              child: Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[700],
              onPressed: () {},
              shape: CircleBorder(),
              foregroundColor: Colors.white,
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
