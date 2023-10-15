#pragma once
#include <QDebug>
#include <QObject>
#include <QQmlEngine>
#include <QQmlContext>
#include <QSettings>

#include <libudev.h>

#include "dbus_interface.h"

class QuickSettings : public QObject
{
    Q_OBJECT
    
public:
    QuickSettings(QObject* parent = 0);
    ~QuickSettings();
    Q_INVOKABLE unsigned int GetMaxBrightness();
    Q_INVOKABLE void SetBrightness(unsigned int value);
    void refreshBatteryInfo();

private:
    org::freedesktop::DBus::Properties *battery;

    struct udev *udevInstance;
    struct udev_enumerate *udevEnumerator;
    struct udev_list_entry *udevEntry;
    struct udev_device *udevDevice;
    int p_maxBrightness;

public Q_SLOTS:
    void onUPowerInfoChanged(QString interface, QVariantMap, QStringList);
};