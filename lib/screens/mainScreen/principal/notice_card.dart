import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    required this.title,
    required this.reason,
    required this.content,
    required this.formattedDate,
    required this.name,
    this.url,
  });

  final String content;
  final String formattedDate;
  final String name;
  final String reason;
  final String title;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;

    // Define responsive sizes based on screen width
    double baseFontSize = deviceWidth / 500; // 375 is the width of a standard mobile screen
    double titleFontSize = baseFontSize * (deviceWidth > 600 ? 10 : 20);
    double subtitleFontSize = baseFontSize * (deviceWidth > 600 ? 5 : 16);
    double contentFontSize = baseFontSize * (deviceWidth > 600 ? 7 : 14);

    double imageHeight = deviceWidth * 0.6; // 60% of the screen width

    // Define icon size based on screen width
    double iconRadius = deviceWidth > 600 ? 40 : 30;

    // Define padding based on screen width
    double padding = deviceWidth > 600 ? 40 : 20;

    return Container(
      child: Card(
        margin: EdgeInsets.all(padding),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila de información
              Row(
                children: [
                  CircleAvatar(
                    radius: iconRadius,
                    child: Text(
                      "N",
                      style: TextStyle(fontSize: iconRadius / 2),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSize,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Color.fromARGB(255, 110, 110, 110),
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Texto de la notificación
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                reason,
                style: TextStyle(
                  fontSize: contentFontSize,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                content,
                style: TextStyle(
                  fontSize: contentFontSize,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              // Imagen
              if (url != null) // Mostrar la imagen solo si hay URL
                Container(
                  height: deviceWidth > 800 ? 500 : imageHeight, // Ajusta el tamaño de la imagen según el dispositivo
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(url!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}