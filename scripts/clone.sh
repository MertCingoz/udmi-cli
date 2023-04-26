#!/usr/bin/env sh
set -o errexit -o nounset

git clone --branch "$UDMI_TAG" https://github.com/faucetsdn/udmi.git . || true
git checkout --detach "$UDMI_VERSION"

filePath=pubber/src/main/java/daq/pubber/LocalnetManager.java
sed 's/= getDefaultInterface()/= "eth0"/g' "$filePath" > tmp
mv tmp "$filePath"

filePath=validator/src/main/java/com/google/daq/mqtt/sequencer/sequences/DiscoverySequences.java
sed '/int expected = SCAN_ITERATIONS/,/received <= expected + 1);/c\
    Set<String> eventFamilies = receivedEvents.stream()\
        .flatMap(event -> event.families.keySet().stream())\
        .collect(Collectors.toSet());\
    assertTrue(\"all requested families present\", eventFamilies.containsAll(families));\
    Map<String, List<DiscoveryEvent>> receivedEventsGrouped = receivedEvents.stream()\
        .collect(Collectors.groupingBy(e -> e.scan_family + "." + e.scan_addr));\
    assertTrue("scan iteration", receivedEventsGrouped.values().stream().allMatch(list -> list.size() == SCAN_ITERATIONS));' "$filePath" > tmp
mv tmp "$filePath"

bin/clone_model
bin/genkeys sites/udmi_site_model
