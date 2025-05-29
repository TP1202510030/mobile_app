import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/ui/actuator_icon.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';

class GrowRoomCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final List<ParameterIcon> parameters;
  final List<ActuatorIcon> actuators;

  const GrowRoomCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.parameters,
    required this.actuators,
  });

  @override
  State<GrowRoomCard> createState() => _GrowRoomCardState();
}

class _GrowRoomCardState extends State<GrowRoomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2.0,
        ),
      ),
      elevation: 0,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 85.0,
                height: 85.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 64.0),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        ...widget.actuators,
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: widget.parameters,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
