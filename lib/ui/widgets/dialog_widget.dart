import 'package:flutter/material.dart';
import 'package:test_app/utils/strings.dart';

class ButtonEntity{
  final Function() onTap;
  final String title;

  ButtonEntity({required this.title, required this.onTap});
}

class DialogWidget extends StatelessWidget{
  final String message;
  final List<ButtonEntity> buttonEntities;

  const DialogWidget({Key? key, required this.message, required this.buttonEntities})
      : assert(buttonEntities.length == 0 || buttonEntities.length <= 2),
        super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: SizedBox(
      height: 120,
      child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                )),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(buttonEntities.length, (index) => GestureDetector(
                        onTap: buttonEntities[index].onTap,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            height: 26,
                            alignment: Alignment.center,
                            child: Text(
                              buttonEntities[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            )
                        )))))
          ]),
    ),
  );
}