import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'nimbus-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

type NimbusReactNativeProps = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'NimbusReactNativeView';

export const NimbusReactNativeView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<NimbusReactNativeProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
