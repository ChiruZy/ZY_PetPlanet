//
//  UserTableViewCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UserCell.h"
#import "Common.h"

@interface UserTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray<UsersModel *> *models;
@end

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellWithReuseIdentifier:@"UserCell"];
}


- (void)configWithUserModels:(NSArray<UsersModel *> *)models{
    _models = models;
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_models.count == 0){
        return 0;
    }
    return _models.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    if (indexPath.row == _models.count) {
        [cell configWithName:@"More" Image:[UIImage imageNamed:@"more"]];
        return cell;
    }
    [cell configWithUserModel:_models[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_block) {
        if (indexPath.row >= _models.count) {
            _block(nil);
            return;
        }
        _block(_models[indexPath.row]);
    }
}

@end
