import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/text/cubit/text_service_cubit.dart';
import 'package:uuid/uuid.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});
  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  final TextEditingController textEditingController = TextEditingController();
  late FocusNode focusNode;
  var idDevice = const Uuid().v1();
  @override
  void initState() {
    super.initState();
    context.read<TextServiceCubit>().getController(idDevice: idDevice);
    focusNode = FocusNode();
    /* focusNode.addListener(() {
      if (focusNode.hasFocus) {
        context.read<TextServiceCubit>().changeTyping(idDevice, true);
      } else {
        context.read<TextServiceCubit>().changeTyping(idDevice, false);
      }
    });*/
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        context.read<TextServiceCubit>().changeTyping(idDevice, false);
      },
      child: Scaffold(
        body: BlocBuilder<TextServiceCubit, TextServiceState>(
          builder: (context, state) {
            if (state is TextServiceLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TextServiceSucces) {
              if (textEditingController.text != state.textController.text &&
                  idDevice != state.idTyping) {
                print("here text editing");
                print(idDevice);
                textEditingController.text = state.textController.text;
                // textEditingController.selection =
                //     TextSelection.collapsed(offset: state.index);
              }
              // if (state.timeOut == true && state.idTyping == idDevice) {
              //   // FocusScope.of(context).unfocus();
              //   // context.read<TextServiceCubit>().changeVide();
              //   print(state.timeOut);
              //   state.timeOut = false;
              // }
              print("here scaffold ");
              return Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    state.whoTyping == true
                        ? Text("the user with id:${state.idTyping}",
                            style: const TextStyle(color: Colors.blue))
                        : Container(),
                    TextField(
                      controller: textEditingController,
                      // // enabled:
                      // // //  (state.whoTyping == true &&
                      // // //         state.idTyping == idDevice) ||
                      // // //     state.whoTyping == false
                      //     ,
                      focusNode: focusNode,
                      onChanged: (name) {
                        context.read<TextServiceCubit>().updateText(
                            name,
                            textEditingController.selection.baseOffset,
                            idDevice);
                        // context.read<TextServiceCubit>().updateUserName(
                        //     name, textEditingController.selection.baseOffset);
                      },
                    )
                  ],
                ),
              );
            }
            return const Text("not found 404");
          },
        ),
      ),
    );
  }
}
