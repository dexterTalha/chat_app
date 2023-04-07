import 'package:flutter/material.dart';

class FriendRowWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final void Function()? onAccept;
  final void Function()? onReject;
  final bool isRequest;
  final Function()? onTap;
  const FriendRowWidget({super.key, this.name, this.email, this.isRequest = false, this.onAccept, this.onReject, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const FlutterLogo(
        size: 40,
      ),
      title: Text(
        name ?? "",
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(email ?? ""),
      trailing: SizedBox(
        height: 70,
        width: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: isRequest,
              child: GestureDetector(
                onTap: onAccept,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    border: Border.all(color: Colors.green, width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onReject,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  border: Border.all(color: Colors.red, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return Row(
    //   children: [
    //     const FlutterLogo(),
    //     Expanded(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             name ?? "",
    //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
