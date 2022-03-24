import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: kPrussianBlue,
                  child: const Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://scontent-sin6-2.cdninstagram.com/v/t51.2885-19/182182852_152849586845588_4263059098943298039_n.jpg?stp=dst-jpg_s320x320&_nc_ht=scontent-sin6-2.cdninstagram.com&_nc_cat=108&_nc_ohc=RJN6VKSqQQIAX_VlbjB&edm=ABfd0MgBAAAA&ccb=7-4&oh=00_AT_kGn9XoGy8mYk7KUgkEKQ379N3wUNptT8mQpVjAun2Yg&oe=6242A76B&_nc_sid=7bff83'),
                      maxRadius: 80,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: kMikadoYellow,
                  child: const Text(
                    'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          )
        ],
      ),
    );
  }
}
