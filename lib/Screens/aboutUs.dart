import 'package:flutter/material.dart';

import 'package:status_saver_ws/colors.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:ws/colors.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
  }

  late Color primery;
  late Color secondry;
  late Color textColor;

  @override
  Widget build(BuildContext context) {
    var _url =
        "https://play.google.com/store/apps/details?id=com.kedhar.status_saver_ws";

    var samurl = "https://apps.samsung.com/appquery/AppRating.as?appId=com.kedhar.status_saver_ws";

    void _launchURL() async => await canLaunch(samurl)
        ? await launch(samurl)
        : throw 'Could not launch $samurl';

    void _launchPrivacyPolicy() async => await canLaunch(
            "https://kedhar-app-development-studios.github.io/Privacy-Policy/")
        ? await launch(
            "https://kedhar-app-development-studios.github.io/Privacy-Policy/")
        : throw "could not launch url";
    bool themeIsDark = Theme.of(context).brightness == Brightness.dark;
    primery = Theme.of(context).brightness == Brightness.dark
        ? ColorsClass.primeDark
        : ColorsClass.primeWhite;
    secondry = Theme.of(context).brightness == Brightness.dark
        ? ColorsClass.secondryDark
        : ColorsClass.secondryWhite;
    textColor = themeIsDark ? ColorsClass.icon : Colors.grey;
    return Scaffold(
      backgroundColor: primery,
      appBar: AppBar(
          backgroundColor: primery,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: ColorsClass.icon,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "About Us",
            style: TextStyle(color: textColor),
          )),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(height: 30),
              Image.asset(
                "assets/app_icon.png",
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                "Status Saver",
                style: TextStyle(fontSize: 30, color: ColorsClass.green),
              )),
              SizedBox(height: 10),
              Center(
                  child: Text(
                "V1.0.0",
              )),
              SizedBox(height: 50),
              ListTile(
                title: Text("Privacy Policy"),
                onTap: () => _launchPrivacyPolicy(),
              ),
              ListTile(
                title: Text("Desclaimer"),
                onTap: () => showAlertDialog(context),
              ),
              ListTile(
                title: Text("Report"),
                subtitle: Text(
                    "Found any bugs or have any suggestions? Let us Know!"),
                onTap: () => _launchURL(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext scontext) {
    Widget okButton = TextButton(
      child: Text("Got it"),
      onPressed: () {
        Navigator.pop(scontext);
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: primery,
      title: Text("Disclaimer"),
      content: Container(
        color: secondry,
        height: 300,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "- Status Saver is not affiliated with WhatsApp. its a tool for downloading Status from WhatsApp.\n\n- We respect the copyright of the owners/creators of Status. So please do not download any posts without owner's consent.\n\n- Status Saver is only for your personal study and research, so do not use our service to download Status for any commercial use.\n\n- We(Status Saver / Kedhar Studios) are not responsible if you are using our services for any illegal activities.\n\n-You understand that you are responsible for any possible infringement when you download or share copyrighted material without the copyright holder's consent."),
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
