import {
	StyleSheet,
	TouchableOpacity,
	ColorPropType,
	Text
} from 'react-native';
import { bool, func, string } from 'prop-types';
import React, { Component } from 'react';

class Cmd extends Component<*> {
  static propTypes = {
    accessibilityLabel: string,
    color: ColorPropType,
    disabled: bool,
    onPress: func.isRequired,
    testID: string,
    title: string.isRequired
  };

  render() {
    const { accessibilityLabel, color, disabled, onPress, testID, title } = this.props;

    return (
      <TouchableOpacity
        accessibilityLabel={accessibilityLabel}
        accessibilityRole="button"
        disabled={disabled}
        onPress={onPress}
        style={styles.button}
        testID={testID}
      >
        <Text style={[styles.text, disabled && styles.textDisabled, color && { color: color }]}>{title}</Text>
      </TouchableOpacity>
    );
  }
}

const styles = StyleSheet.create({
  button: {
    borderRadius: 2
  },
  text: {
    color: '#2196F3',
    fontWeight: '500',
    padding: 8,
    textAlign: 'left',
    textTransform: 'uppercase'
  },
  textDisabled: {
    color: '#a1a1a1'
  }
});

export default Cmd;
