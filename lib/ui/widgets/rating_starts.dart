part of 'widgets.dart';

class RatingStars extends StatelessWidget {
  // const RatingStars({ Key? key }) : super(key: key);
  final double rate;

  RatingStars(this.rate);

  @override
  Widget build(BuildContext context) {
    int numberofStars = rate.round();

    return Row(
      children: List<Widget>.generate(
              5,
              (index) => Icon(
                    (index < numberofStars) ? MdiIcons.star : MdiIcons.starOutline,
                    size: 16,
                    color: mainColor,
                  )) +
          [
            SizedBox(
              width: 4,
            ),
            Text(
              rate.toString(),
              style: greyFontStyle.copyWith(fontSize: 12),
            )
          ],
    );
  }
}
