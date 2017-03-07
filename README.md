# interested-point


### Algorithm Steps:
1. get interested points using Harris algorithm
get_interest_points(image, feature_width)<br>
2. find features for each interested points using SIFT method
get_features(image, x, y, feature_width)<br>
3. compute Euclidean distance for each feature to match vailed interested points
match_features(features1, features2)<br>
