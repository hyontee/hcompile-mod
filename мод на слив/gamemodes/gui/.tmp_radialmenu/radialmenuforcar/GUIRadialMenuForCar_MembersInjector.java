package com.blackhub.bronline.game.gui.radialmenuforcar;

import com.blackhub.bronline.game.gui.radialmenuforcar.viewmodel.RadialMenuViewModel;
import com.blackhub.bronline.launcher.viewmodel.MainViewModelFactory;
import dagger.MembersInjector;
import dagger.internal.DaggerGenerated;
import dagger.internal.InjectedFieldSignature;
import dagger.internal.Provider;
import dagger.internal.QualifierMetadata;

@DaggerGenerated
@QualifierMetadata
/* loaded from: classes4.dex */
public final class GUIRadialMenuForCar_MembersInjector implements MembersInjector<GUIRadialMenuForCar> {
    public final Provider<MainViewModelFactory<RadialMenuViewModel>> radialMenuFactoryProvider;

    public GUIRadialMenuForCar_MembersInjector(Provider<MainViewModelFactory<RadialMenuViewModel>> radialMenuFactoryProvider) {
        this.radialMenuFactoryProvider = radialMenuFactoryProvider;
    }

    @Override // dagger.MembersInjector
    public void injectMembers(GUIRadialMenuForCar instance) {
        injectRadialMenuFactory(instance, this.radialMenuFactoryProvider.get());
    }

    public static MembersInjector<GUIRadialMenuForCar> create(Provider<MainViewModelFactory<RadialMenuViewModel>> radialMenuFactoryProvider) {
        return new GUIRadialMenuForCar_MembersInjector(radialMenuFactoryProvider);
    }

    @InjectedFieldSignature("com.blackhub.bronline.game.gui.radialmenuforcar.GUIRadialMenuForCar.radialMenuFactory")
    public static void injectRadialMenuFactory(GUIRadialMenuForCar instance, MainViewModelFactory<RadialMenuViewModel> radialMenuFactory) {
        instance.radialMenuFactory = radialMenuFactory;
    }
}