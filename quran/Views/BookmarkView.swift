//
//  BookmarkView.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

struct BookmarkView: View {
    // MARK: - PROPERTIES
    let textAspect = 1.0
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @StateObject private var viewModel = ViewModel()
    
    let NewBookmarkFolderHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    let NewBookmarkSortHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    
    let bookmarkItemFolderHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    let bookmarkItemMoreHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    
    let FolderItemIndexHeight = 40.0 * UIScreen.main.bounds.height / 812.0
    let FolderItemBookmarkHeight = 32.0 * UIScreen.main.bounds.height / 812.0
    
    let popupViewRound = 20.0 * UIScreen.main.bounds.height / 812.0
    let popupBottomSpacing = 80.0 * UIScreen.main.bounds.height / 812.0 + UIDevice.bottomIndicatorHeight
    
    let sorts = ["surah number", "bookmark date"]
    
    
    let fontStyleItemHeight = 52.0 * UIScreen.main.bounds.height / 812.0
    let fontStyleItemWidth = UIScreen.main.bounds.width - 48.0
    @Namespace var namespace
    
    
    let buttonSize = CGSize(width: 100.0 * UIScreen.main.bounds.width / 374.0, height: 45.0 * UIScreen.main.bounds.height / 812.0)
    
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24.0) {
                HeaderSectionView(content: "Bookmarks", leftItem: "menu") {
                    
                    // view dismissed
                    viewModel.fileManager = nil
                    print(" - BookmarkView dismissed!")
                }
                if viewModel.folders.count == 0 {
                    AddFolderView()
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        FoldersView()
                    }
                }
            }
        }
        .padding(.horizontal, 24.0)
        .background(
            Color("screen-bg")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        )
        .popup(isPresented: $viewModel.showFolderEditPopUp, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            FolderItemEditPopUpView()
        }
        .popup(isPresented: $viewModel.showAddNewFolderPopUp, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            AddNewFolderPopUpView()
        }
        .popup(isPresented: $viewModel.showFolderSortPopUp, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            SortFolderPopUpView()
        }
        .onDisappear {
            // view disappeared
            viewModel.fileManager = nil
            print(" > BookmarkView disappeared!")
        }
    }
    
    
    
    
    // MARK: - VIEWS
    
    
    
    
    // MARK: - SortKindSelectorView
    @ViewBuilder
    func SortKindSelectorItemView(sort: String) -> some View {
        ZStack(alignment: .center) {
            Text(sort)
                .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                .foregroundColor(
                    viewModel.SortSelectorValue == sort ?
                        Color("popup-tab-selected-text") :
                        Color("popup-tab-not-selected-text")
                )
            
            if(viewModel.SortSelectorValue == sort) {
                ZStack(alignment: .bottom) {
                    VStack (alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle()
                            .frame(height: 3.0)
                            .foregroundColor(Color("popup-tab-indicator"))
                    }
                }
                .matchedGeometryEffect(id: "language-item", in: namespace)
            }
            
        }
        .onTapGesture {
            withAnimation(.default) {
                viewModel.SortSelectorValue = sort
            }
        }
        .frame(width: fontStyleItemWidth / CGFloat(sorts.count), height: fontStyleItemHeight)
    }
    
    @ViewBuilder
    func SortKindSelectorView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(sorts, id:\.self) { sort in
                SortKindSelectorItemView(sort: sort)
            }
        }
    }
    
    
    
    
    
    
    // MARK: - SortFolderPopUpView
    @ViewBuilder
    func SortFolderPopUpView() -> some View {
        VStack(alignment: .center, spacing: 16.0) {
            HStack(alignment: .center) {
                Text("Sort Collections")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
            }
            
            Rectangle()
                .frame(height: 1.0)
                .foregroundColor(Color("popup-divider"))
                .padding(.vertical, 8.0)
            
            SortKindSelectorView()
                .onChange(of: viewModel.SortSelectorValue) { newValue in
                    if newValue == sorts[0] {
                        // sort by surah #
                        viewModel.bookmarks =  viewModel.fileManager?.sortBookmarks(bookmarks: viewModel.bookmarks, by: .surah) ?? []
                        viewModel.setBookmarkFolderItems()
                    } else {
                        // sort by date
                        viewModel.bookmarks =  viewModel.fileManager?.sortBookmarks(bookmarks: viewModel.bookmarks, by: .date) ?? []
                        viewModel.setBookmarkFolderItems()
                    }
                }
        }
        .padding(.top, 24.0)
        .padding(.bottom, keyboardHeightHelper.keyboardHeight > 0 ? keyboardHeightHelper.keyboardHeight + UIDevice.bottomIndicatorHeight : popupBottomSpacing)
        .padding(.horizontal, 24.0)
        .frame(width: UIScreen.main.bounds.width - popupViewRound)
        .background(Color("popup-bg"))
        .cornerRadius(popupViewRound)
        .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
    }
    
    
    
    
    
    
    
    // MARK: - AddNewFolderPopUpView
    @ViewBuilder
    func AddNewFolderPopUpView() -> some View {
        VStack(alignment: .center, spacing: 16.0) {
            HStack(alignment: .center) {
                Text("Add new Collection")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
            }
            
            Rectangle()
                .frame(height: 1.0)
                .foregroundColor(Color("popup-divider"))
                .padding(.vertical, 8.0)
            
            TextField(viewModel.showFolderEditTitleValue, text: $viewModel.showFolderEditTitleValue)
                .lineLimit(1)
                .disableAutocorrection(true)
                .font(.custom("Poppins-Bold", size: 18.0 * textAspect))
                .foregroundColor(Color("popup-textfield-text"))
                .frame(height: 50.0)
                .padding(.horizontal, 24.0)
                .background(Color("popup-textfield-bg"))
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                
            ZStack {
                RoundedRectangle(cornerRadius: buttonSize.height / 2.0, style: .continuous)
                    .frame(width: buttonSize.width, height: buttonSize.height)
                    .foregroundColor(Color("popup-normal-button-bg"))
                
                Text("Add")
                    .font(.custom("Poppins-SemiBold", size: 18 * buttonSize.height / 60))
                    .foregroundColor(Color("popup-button-text"))
            }
            .onTapGesture {
                hideKeyboard()
                if viewModel.showFolderEditTitleValue != "" {
                    viewModel.showAddNewFolderPopUp.toggle()
                    viewModel.folders =  viewModel.fileManager?.addFolder(title: viewModel.showFolderEditTitleValue) ?? []
                    viewModel.showFolderEditTitleValue = ""
                }
            }
            .padding(.vertical, 8.0)
        }
        .padding(.top, 24.0)
        .padding(.bottom, keyboardHeightHelper.keyboardHeight > 0 ? keyboardHeightHelper.keyboardHeight + UIDevice.bottomIndicatorHeight : popupBottomSpacing)
        .padding(.horizontal, 24.0)
        .frame(width: UIScreen.main.bounds.width - popupViewRound)
        .background(Color("popup-bg"))
        .cornerRadius(popupViewRound)
        .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
    }
    
    
    
    
    
    
    
    // MARK: - FolderItemEditPopUpView
    @ViewBuilder
    func FolderItemEditPopUpView() -> some View {
        if let folderItem = viewModel.showingFolderEditPopUpItem {
            
            VStack(alignment: .center, spacing: 16.0) {
                HStack(alignment: .center) {
                    Text("\(folderItem.title) Collection")
                        .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                        .foregroundColor(Color("popup-text"))
                    
                    Spacer()
                }
                
                Rectangle()
                    .frame(height: 1.0)
                    .foregroundColor(Color("popup-divider"))
                    .padding(.vertical, 8.0)
                
                TextField(viewModel.showFolderEditTitleValue, text: $viewModel.showFolderEditTitleValue)
                    .lineLimit(1)
                    .disableAutocorrection(true)
                    .font(.custom("Poppins-Bold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-textfield-text"))
                    .frame(height: 50.0)
                    .padding(.horizontal, 24.0)
                    .background(Color("popup-textfield-bg"))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    
                HStack(spacing: 24.0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: buttonSize.height / 2.0, style: .continuous)
                            .frame(width: buttonSize.width, height: buttonSize.height)
                            .foregroundColor(Color("popup-normal-button-bg"))
                        
                        Text("Rename")
                            .font(.custom("Poppins-SemiBold", size: 18 * buttonSize.height / 60))
                            .foregroundColor(Color("popup-button-text"))
                    }
                    .onTapGesture {
                        hideKeyboard()
                        if viewModel.showFolderEditTitleValue != "" {
                            viewModel.showFolderEditPopUp.toggle()
                            
                            viewModel.folders =  viewModel.fileManager?.renameFolder(with: viewModel.showingFolderEditPopUpItem?.id ?? "", renameTo: viewModel.showFolderEditTitleValue) ?? []
                            
                            viewModel.showingFolderEditPopUpItem = nil
                            viewModel.showFolderEditTitleValue = ""
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: buttonSize.height / 2.0, style: .continuous)
                            .frame(width: buttonSize.width, height: buttonSize.height)
                            .foregroundColor(Color("popup-delete-button-bg"))
                        
                        Text("Delete")
                            .font(.custom("Poppins-SemiBold", size: 18 * buttonSize.height / 60))
                            .foregroundColor(Color("popup-button-text"))
                    }
                    .onTapGesture {
                        viewModel.showFolderEditPopUp.toggle()
                        
                        viewModel.folders =  viewModel.fileManager?.removeFolder(with: viewModel.showingFolderEditPopUpItem?.id ?? "") ?? []
                        viewModel.bookmarks = viewModel.fileManager?.loadBookmarks() ?? []
                        viewModel.showingFolderEditPopUpItem = nil
                    }
                }
                .padding(.vertical, 8.0)

            }
            .padding(.top, 24.0)
            .padding(.bottom, keyboardHeightHelper.keyboardHeight > 0 ? keyboardHeightHelper.keyboardHeight + UIDevice.bottomIndicatorHeight : popupBottomSpacing)
            .padding(.horizontal, 24.0)
            .frame(width: UIScreen.main.bounds.width - popupViewRound)
            .background(Color("popup-bg"))
            .cornerRadius(popupViewRound)
            .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
        }
    }
    
    
    
    
    
    
    
    // MARK: - AddFolderView
    @ViewBuilder
    func AddFolderView() -> some View {
        HStack(alignment: .center, spacing: 8.0) {
            
            HStack(alignment: .center, spacing: 8.0) {
                
                Image("bookmark-folder-add-image")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("bookmark-folder"))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: NewBookmarkFolderHeight)
                
                Text("Add new Collection")
                    .lineLimit(1)
                    .allowsTightening(false)
                    .font(.custom("Poppins-Medium", size: 16.0 * textAspect))
                    .foregroundColor(Color("bookmark-add-new-text"))
                
            }
            .clipped()
            .onTapGesture {
                viewModel.showFolderEditTitleValue = ""
                viewModel.showAddNewFolderPopUp.toggle()
            }
            
            Spacer()
            
            Image("bookmark-sort-image")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color("bookmark-sort"))
                .aspectRatio(contentMode: .fit)
                .frame(height: NewBookmarkSortHeight)
                .clipped()
                .onTapGesture {
                    viewModel.showFolderSortPopUp.toggle()
                }
            
        }
    }
    
    
    
    
    
    
    // MARK: - FoldersView
    @ViewBuilder
    func FolderItemBookmarksView(item: BookmarkItemModel) -> some View {
        
        NavigationLink(isActive: $viewModel.showSurahDetailViewFromBookmark) {
            if let surah = surahItemExample.first(where: { searchItem in
                searchItem.index == item.surah
            }) {
                SurahDetailsView(surah: surah, aye: item.ayah)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
            }
        } label: {
            EmptyView()
        }
        
        HStack(alignment: .center, spacing: 16.0) {
            
            ZStack(alignment: .center) {
                Image("content-item-index")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("content-item-index-icon"))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: FolderItemIndexHeight)
                
                Text("\(item.surah.description)")
                    .font(.custom("Poppins-Medium", size: 14 * textAspect))
                    .foregroundColor(Color("content-item-surah-index-text"))
            }
            
            VStack(alignment: .leading, spacing: 4.0) {
                Text(item.surahTitle)
                    .font(.custom("Poppins-Regular", size: 16.0 * textAspect))
                    .foregroundColor(Color("bookmark-item-title-text"))
                
                Text("verse \(item.ayah.description)")
                    .textCase(.uppercase)
                    .font(.custom("Poppins-Regular", size: 12.0 * textAspect))
                    .foregroundColor(Color("bookmark-item-subtitle-text"))
            }
            
            Rectangle()
                .foregroundColor(Color("screen-bg"))
            
            HStack {
                Image("ayat-section-header-bookmark-image-active")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("content-item-index-icon"))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: FolderItemBookmarkHeight)
            }
            .clipped()
            .onTapGesture {
                // remove item from parent
                _ =  viewModel.fileManager?.removeBookmark(with: item.id) ?? []
                viewModel.bookmarks = viewModel.fileManager?.loadBookmarks() ?? []
                viewModel.folders = viewModel.fileManager?.loadBookmarkFolders() ?? []
                viewModel.setBookmarkFolderItems()
            }
        }
        .onTapGesture {
            viewModel.showSurahDetailViewFromBookmark.toggle()
        }
    }
    @ViewBuilder
    func FolderItemView(folder: BookmarkFolderModel) -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center, spacing: 16.0) {
                
                VStack(alignment: .leading) {
                    Image("bookmark-item-folder-image")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("bookmark-folder"))
                        .aspectRatio(contentMode: .fit)
                        .frame(height: bookmarkItemFolderHeight)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(folder.title)
                        .font(.custom("Poppins-Medium", size: 16.0 * textAspect))
                        .foregroundColor(Color("bookmark-title-text"))
                    
                    Text("\(folder.items?.count.description ?? 0.description) items")
                        .font(.custom("Poppins-Medium", size: 12.0 * textAspect))
                        .foregroundColor(Color("bookmark-subtitle-text"))
                }
                
                Rectangle()
                    .foregroundColor(Color("screen-bg"))
                    .padding(.trailing, 8.0)
                
                Button {
                    viewModel.showingFolderEditPopUpItem = folder
                    viewModel.showFolderEditPopUp.toggle()
                } label: {
                    Image("bookmark-item-more-image")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("bookmark-more"))
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(height: bookmarkItemMoreHeight)
                        .padding(.all, 8.0)
                }
                .buttonStyle(.plain)
                
            }
            
            if(viewModel.toShowItemsBookmarkId == folder.id) {
                if let items = folder.items {
                    LazyVStack(alignment: .center, spacing: 16.0) {
                        ForEach(items, id: \.self) { item in
                            FolderItemBookmarksView(item: item)
                        }
                    }
                    .padding(.leading, 24.0)
                    .padding(.vertical, 8.0)
                }
            }
        }
            .onTapGesture {
                withAnimation {
                    if (viewModel.toShowItemsBookmarkId == folder.id) {
                        viewModel.toShowItemsBookmarkId = nil
                    } else {
                        viewModel.toShowItemsBookmarkId = folder.id
                    }
                }
            }
            .clipped()
            .animation(.spring())
    }
    @ViewBuilder
    func FoldersView() -> some View {
        if viewModel.folders.count > 0 {
            LazyVStack(alignment: .center, spacing: 32.0) {
                AddFolderView()
                ForEach(viewModel.folders) { folder in
                    FolderItemView(folder: folder)
                }
                Spacer(minLength: 64.0)
            }
        }
    }
    
}






// MARK: - PREVIEWS
struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}
