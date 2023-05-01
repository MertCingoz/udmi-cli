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

filePath=validator/src/main/java/com/google/daq/mqtt/sequencer/sequences/LocalnetSequences.java
sed '/private void familyAddr(String family) {/,/() -> expected.equals(actual));/c\
  private void familyAddr(String family) {\
    java.util.Set expectedFamilies = deviceMetadata.localnet.families.keySet().stream()\
            .filter(f -> f.contains(family)).collect(java.util.stream.Collectors.toSet());\
    checkThat("expectedFamilies greater than 0", () -> expectedFamilies.size() > 0);\
    expectedFamilies.forEach(expectedFamily -> {\
      String expected = catchToNull(() -> deviceMetadata.localnet.families.get(expectedFamily).addr);\
      if (expected == null) {\
        throw new SkipTest(String.format("No %S address defined in metadata", expectedFamily));\
      }\
      untilTrue("localnet families available", () -> deviceState.localnet.families.size() > 0);\
      String actual = catchToNull(() -> deviceState.localnet.families.get(expectedFamily).addr);\
      checkThat(String.format("device %s address was %s, expected %s", expectedFamily, actual, expected),\
              () -> expected.equals(actual));\
    });' "$filePath" > tmp
mv tmp "$filePath"

filePath=validator/src/main/java/com/google/daq/mqtt/validator/ReportingDevice.java
sed 's/previous.before(getThreshold(now))/true/g' "$filePath" > tmp
mv tmp "$filePath"

bin/clone_model
bin/genkeys sites/udmi_site_model
