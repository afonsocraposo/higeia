part of '../register.dart';

class NameScreen extends StatefulWidget {
  const NameScreen(this.updateName, {Key key}) : super(key: key);

  final Function updateName;

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.center,
          child: Center(
            child: Text(
              _controller.text.trim().isEmpty
                  ? "Hey you!"
                  : "Hey ${_controller.text.trim().split(" ").first}!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "What's your name?",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 1,
                  onChanged: (String text) {
                    widget.updateName(text.trim());
                    if (text.trim().split(" ").length == 1) setState(() {});
                  },
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(32),
                  ],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: "John Doe",
                    fillColor: Colors.grey.withAlpha(64),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SvgPicture.asset(
            "assets/images/personal-information-left.svg",
            width: 100,
          ),
        ),
      ],
    );
  }
}
