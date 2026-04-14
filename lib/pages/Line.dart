import 'dart:ui';

enum Line
{
  red(name: "Red", color: Color(0xfff0066a), imageLink: "assets/images/redLine.png", start: "São Sebastião", end: "Aeroporto"),
  green(name: "Green", color: Color(0xff11a7a8), imageLink: "assets/images/greenLine.png", start: "Telheiras", end: "Cais do Sodré"),
  yellow(name: "Yellow", color: Color(0xfff1bb13), imageLink: "assets/images/yellowLine.png", start: "Rato", end: "Odivelas"),
  blue(name: "Blue", color: Color(0xff2c6dca), imageLink: "assets/images/blueLine.png", start: "Reboleira", end: "Santa Apolónia");

  const Line({
    required this.name,
    required this.color,
    required this.imageLink,
    required this.start,
    required this.end,
  });

  final String name;  //Line name (color)
  final Color color;  //Hex code for color
  final String imageLink; //Link to the icon
  final String start; //Station where it starts
  final String end; //Station where it ends

  static Line? getByName(String name)
  {
    Line? res;
    for(Line line in values)
      {
        if(line.name == name)
          {
            res = line;
          }
      }
    return res;
  }

}