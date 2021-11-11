part of 'pages.dart';

class ProfilPage extends StatefulWidget {
  // const ProfilPage({ Key? key }) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // *Header
        Container(
          height: 220,
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          margin: EdgeInsets.only(bottom: defaultMargin),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/photo_border.png'),
                )),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage((context.read<UserCubit>().state as UserLoaded).user.picturePath!),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Text(
                (context.read<UserCubit>().state as UserLoaded).user.name!,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text((context.read<UserCubit>().state as UserLoaded).user.email!,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w300))
            ],
          ),
        ),
        // *Costum Tabbar
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              CustomTabBar(
                titles: ['Account', 'FoodMarket'],
                selectedIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                  children: ((selectedIndex == 0)
                          ? ['Edit Profile', 'Home Address', 'Security', 'Payment']
                          : ['Rate App', 'Help Center', 'Privacy & Policy', 'Term & Condition'])
                      .map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 16, left: defaultMargin, right: defaultMargin),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e,
                                style: blackFontStyle3,
                              ),
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                  'assets/right_arrow.png',
                                  fit: BoxFit.contain,
                                ),
                              )
                            ],
                          )))
                      .toList())
            ],
          ),
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}
