import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/ui/actuator_icon.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/core/ui/button.dart';

class GrowRoomCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final List<ParameterIcon> parameters;
  final VoidCallback? onTap;
  final List<ActuatorIcon>? actuators;
  final bool hasActiveCrop;
  final VoidCallback? onStartCrop;

  const GrowRoomCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.parameters,
    this.onTap,
    this.actuators,
    required this.hasActiveCrop,
    this.onStartCrop,
  });

  @override
  State<GrowRoomCard> createState() => _GrowRoomCardState();
}

class _GrowRoomCardState extends State<GrowRoomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.hasActiveCrop ? widget.onTap : null,
      child: Card(
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
                        if (widget.hasActiveCrop) ...?widget.actuators,
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    if (widget.hasActiveCrop)
                      if (widget.parameters.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: widget.parameters,
                        )
                      else
                        Text(
                          'Aún no hay mediciones disponibles.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        )
                    else
                      CustomButton(
                        onTap: () {
                          widget.onStartCrop?.call();
                        },
                        child: Text(
                          'Iniciar cultivo',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
