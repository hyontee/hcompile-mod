package com.blackhub.bronline.game.gui.radialmenuforcar.viewmodel;

import com.blackhub.bronline.game.gui.radialmenuforcar.netrowk.RadialMenuActionWithJSON;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.Provider;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;

@ScopeMetadata
@DaggerGenerated
@QualifierMetadata
/* loaded from: classes4.dex */
public final class RadialMenuViewModel_Factory implements Factory<RadialMenuViewModel> {
    public final Provider<RadialMenuActionWithJSON> actionWithJsonProvider;

    public RadialMenuViewModel_Factory(Provider<RadialMenuActionWithJSON> actionWithJsonProvider) {
        this.actionWithJsonProvider = actionWithJsonProvider;
    }

    @Override // javax.inject.Provider, jakarta.inject.Provider
    public RadialMenuViewModel get() {
        return newInstance(this.actionWithJsonProvider.get());
    }

    public static RadialMenuViewModel_Factory create(Provider<RadialMenuActionWithJSON> actionWithJsonProvider) {
        return new RadialMenuViewModel_Factory(actionWithJsonProvider);
    }

    public static RadialMenuViewModel newInstance(RadialMenuActionWithJSON actionWithJson) {
        return new RadialMenuViewModel(actionWithJson);
    }
}